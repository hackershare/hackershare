# frozen_string_literal: true

class BookmarkRobotJob < ApplicationJob
  queue_as :hardly

  def perform(code)
    rss_source = RssSource.find_by!(code: code)
    processed_at = Time.current
    res = http.get(rss_source.url)
    feed = Feedjira.parse(res.to_s)
    return if rss_source.processed_at && rss_source.processed_at > feed.last_built

    entries = rss_source.limit ? feed.entries.take(rss_source.limit) : feed.entries
    entries.reverse_each do |entry|
      next if User.rss_robot.bookmarks.exists?(url: entry.url)

      title = entry.title.force_encoding("utf-8")
      description = (entry.summary || entry.content).force_encoding("utf-8")
      title = description if %w[manong_weekly].include?(rss_source.code)
      lang = [title, description].any? { |text| text.match?(/\p{Han}/) } ? :chinese : :english
      bookmark = User.rss_robot.bookmarks.new(
        is_rss:      true,
        url:         entry.url,
        title:       title,
        description: description,
        created_at:  entry.published,
        lang:        lang,
      )
      if bookmark.save
        if !rss_source.tag
          tag = Tag.find_by(name: rss_source.tag_name)
          if tag
            tag.update!(is_rss: true)
            rss_source.update!(tag: tag)
          else
            rss_source.create_tag!(is_rss: true, name: rss_source.tag_name, user: User.rss_robot)
          end
        end
        CreateTag.call(bookmark, [rss_source.tag.name], User.rss_robot)
      else
        logger.error "[BookmarkRobotJob] Save bookmark failed: #{bookmark.errors.full_messages.to_sentence}"
      end
    end
    rss_source.touch(:processed_at, time: processed_at)
  end

  private

    def http
      @http ||= \
        if proxy = ENV["https_proxy"] || ENV["http_proxy"]
          uri = URI.parse(proxy)
          HTTP.via(uri.host, uri.port)
        else
          HTTP
        end
    end
end
