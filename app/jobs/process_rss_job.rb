# frozen_string_literal: true

class ProcessRssJob < ApplicationJob
  queue_as :hardly

  def perform(rss_source_id)
    rss_source = RssSource.find(rss_source_id)
    process_rss_source(rss_source)
  end

  private

  def process_rss_source(rss_source)
    processed_at = Time.current
    res = http.get(rss_source.url)
    feed = Feedjira.parse(res.to_s)
    if rss_source.processed_at && feed.try(:last_built)
      last_built_date = \
        if feed.last_built.is_a?(String)
          Time.zone.parse(feed.last_built).to_date
        else
          feed.last_built.to_date
        end
      if rss_source.processed_at.to_date > last_built_date
        return
      end
    end
    init_rss_source_tag!(rss_source)
    smart_published_at_array = \
      if feed.entries.map(&:published).uniq.size == 1
        get_smart_published_at_array(rss_source, feed.entries.size)
      else
        []
      end
    feed.entries.reverse_each.with_index do |entry, index|
      url = get_complete_url(rss_source.url, entry.url)
      next if User.rss_robot.bookmarks.exists?(url: url)
      title = entry.title&.force_encoding("utf-8")
      description = (entry.content || entry.summary)&.force_encoding("utf-8")
      lang = [title, description].any? { |text| text.to_s.match?(/\p{Han}/) } ? :chinese : :english
      created_at = smart_published_at_array[index] || [entry.published, Time.current].min
      bookmark = User.rss_robot.bookmarks.new(
        is_rss: true,
        is_display: rss_source.is_display,
        url: url,
        title: title,
        description: entry.summary&.force_encoding("utf-8"),
        content: description,
        created_at: created_at,
        lang: lang
      )
      if bookmark.save
        CreateTag.call(bookmark, [rss_source.tag_name], User.rss_robot)
      else
        logger.error "[RssRobotJob] Save bookmark failed: #{bookmark.errors.full_messages.to_sentence}"
      end
    end
    rss_source.touch(:processed_at, time: processed_at)
  rescue => e
    logger.error "[RssRobotJob] process #{rss_source.url} failed"
    logger.error e.message
    logger.error e.backtrace.join("\n")
  end

  def init_rss_source_tag!(rss_source)
    if !rss_source.tag
      tag = Tag.find_by(name: rss_source.tag_name)
      if tag
        tag.update!(is_rss: true)
        rss_source.update!(tag: tag)
      else
        rss_source.create_tag!(is_rss: true, name: rss_source.tag_name, user: User.rss_robot)
      end
    end
  end

  def get_smart_published_at_array(rss_source, size)
    start_time = rss_source.tag.bookmarks.maximum(:created_at) || 1.year.ago
    between_time = Time.current - start_time
    order_range = size.times.map { rand }.sort
    order_range.map { |range| start_time + between_time * range }
  end

  def http
    @http ||= begin
      proxy = ENV["https_proxy"] || ENV["http_proxy"]
      if proxy
        uri = URI.parse(proxy)
        HTTP.timeout(20).via(uri.host, uri.port)
      else
        HTTP.timeout(20)
      end
    end
  end

  def get_complete_url(rss_url, entry_url)
    url = URI.parse(entry_url)
    return entry_url if url.host
    rss_url = URI.parse(rss_url)
    url.host = rss_url.host
    url.scheme = rss_url.scheme
    url.port = rss_url.port
    url.to_s
  end
end
