# frozen_string_literal: true

class BookmarkRobotJob < ApplicationJob
  queue_as :hardly

  def perform(name)
    rss_source = RssSource.find_by(name: name)
    return unless rss_source

    processed_at = Time.current
    res = HTTP.get(rss_source.url)
    feed = Feedjira.parse(res.to_s)
    return if rss_source.processed_at && rss_source.processed_at > feed.last_built

    feed.entries.each do |entry|
      next if robot_user.bookmarks.exists?(url: entry.url)

      title = entry.title.force_encoding("utf-8")
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
end
