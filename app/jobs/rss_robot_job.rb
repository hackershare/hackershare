# frozen_string_literal: true

class RssRobotJob < ApplicationJob
  queue_as :hardly

  def perform
    RssSource.find_each do |rss_source|
      process_rss_source(rss_source)
    end
  end

  private

    def process_rss_source(rss_source)
      processed_at = Time.current
      res = http.get(rss_source.url)
      feed = Feedjira.parse(res.to_s)
      if rss_source.processed_at && feed.try(:last_built) && rss_source.processed_at > feed.last_built
        rss_source.touch(:processed_at, time: processed_at)
        return
      end
      feed.entries.reverse_each do |entry|
        next if User.rss_robot.bookmarks.exists?(url: entry.url)
        title = entry.title.force_encoding("utf-8")
        description = (entry.summary || entry.content).force_encoding("utf-8")
        lang = [title, description].any? { |text| text.match?(/\p{Han}/) } ? :chinese : :english
        bookmark = User.rss_robot.bookmarks.new(
          is_rss:      true,
          is_display:  rss_source.is_display,
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
          CreateTag.call(bookmark, [rss_source.tag_name], User.rss_robot)
        else
          logger.error "[RssRobotJob] Save bookmark failed: #{bookmark.errors.full_messages.to_sentence}"
        end
      end
      rss_source.touch(:processed_at, time: processed_at)
    rescue => e
      logger.error "[RssRobotJob] process #{rss_source.tag_name} - #{rss_source.url} failed"
      logger.error e.message
      logger.error e.backtrace.join("\n")
    end

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
