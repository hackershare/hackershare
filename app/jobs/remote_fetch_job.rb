# frozen_string_literal: true

require "open-uri"

class RemoteFetchJob < ApplicationJob
  queue_as :default

  def perform(bookmark_id)
    bookmark = Bookmark.find(bookmark_id)
    parser = LinkThumbnailer.generate(bookmark.url)
    favicon_url = parser.favicon
    begin
      open(parser.favicon, open_timeout: 3)
    rescue OpenURI::HTTPError, Errno::ENOENT
      url_parser = URI.parse(bookmark.url)
      favicon_url = [url_parser.scheme, "://", url_parser.host, "/favicon.ico"].join
      begin
        open(favicon_url, open_timeout: 3)
      rescue OpenURI::HTTPError, Errno::ENOENT
        favicon_url = nil
      end
    end
    bookmark.update(favicon: favicon_url, description: parser.description, title: parser.title)
    bookmark.save_favicon if bookmark.favicon.present?
  rescue LinkThumbnailer::HTTPError
    # TODO
  end
end
