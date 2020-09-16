# frozen_string_literal: true

require "open-uri"

class RemoteFetchJob < ApplicationJob
  queue_as :default

  def perform(bookmark_id)
    bookmark = Bookmark.find(bookmark_id)
    parser = LinkThumbnailer.generate(bookmark.url)
    favicon_url = parser.favicon
    begin
      open(parser.favicon, open_timeout: 8)
    rescue OpenURI::HTTPError, Errno::ENOENT
      url_parser = URI.parse(bookmark.url)
      favicon_url = [url_parser.scheme, "://", url_parser.host, "/favicon.ico"].join
      begin
        result = open(favicon_url, open_timeout: 8)
        favicon_url = nil if /html|text/i.match?(result.content_type)
      rescue OpenURI::HTTPError, Errno::ENOENT
        favicon_url = nil
      end
    end
    lang = [parser.title, parser.description].any? { |text| text.to_s.match?(/\p{Han}/) } ? :chinese : :english
    bookmark.update({ favicon: favicon_url, description: parser.description, title: parser.title, lang: lang }.compact)
    bookmark.save_favicon if bookmark.favicon.present?
  rescue LinkThumbnailer::HTTPError
    # TODO
  end
end
