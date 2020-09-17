# frozen_string_literal: true

class BookmarkRobotJob < ApplicationJob
  queue_as :hardly

  def perform(name)
    rss_source = RssSource.find_by(name: name)
    return unless rss_source

    processed_at = Time.current
    res = http.get(rss_source.url)
    feed = Feedjira.parse(res.to_s)
    return if rss_source.processed_at && rss_source.processed_at > feed.last_built

    entries = rss_source.limit ? feed.entries.take(rss_source.limit) : feed.entries
    entries.each do |entry|
      next if robot_user.bookmarks.exists?(url: entry.url)

      title = \
        if %w[码农周刊].include?(name)
          entry.summary.force_encoding("utf-8")
        else
          entry.title.force_encoding("utf-8")
        end
      summary = entry.summary.force_encoding("utf-8")
      lang = [title, summary].any? { |text| text.match?(/\p{Han}/) } ? :chinese : :english
      bookmark = robot_user.bookmarks.new(
        is_rss:      true,
        url:         entry.url,
        title:       title,
        description: summary,
        created_at:  entry.published,
        lang:        lang,
      )
      if bookmark.save
        CreateTag.call(bookmark, [rss_source.name], robot_user)
      else
        logger.error "[BookmarkRobotJob] Save bookmark failed: #{bookmark.errors.full_messages.to_sentence}"
      end
    end
    rss_source.touch(:processed_at, time: processed_at)
  end

  private

    def robot_user
      @robot_user ||= User.find_by!(username: "hackershare")
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
