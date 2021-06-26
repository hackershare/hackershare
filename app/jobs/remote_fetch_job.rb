# frozen_string_literal: true

require "open-uri"

class RemoteFetchJob < ApplicationJob
  GOOGLE_FAVICON_SERVICE = "https://www.google.com/s2/favicons?domain="
  queue_as :default

  def perform(bookmark_id)
    bookmark = Bookmark.find(bookmark_id)
    if [bookmark.favicon, bookmark.title, bookmark.description, bookmark.lang].all?(&:present?)
      return
    end
    parser = LinkThumbnailer.generate(bookmark.url, verify_ssl: false)
    image_urls = parser.images.sort_by { |image| -image.size[0].to_i }.map(&:src)
    bookmark.title = parser.title.presence if bookmark.title.blank?
    bookmark.description = parser.description.presence if bookmark.description.blank?
    bookmark.images = image_urls if bookmark.images.blank?
    lang = [bookmark.title, bookmark.description].any? { |text| text.to_s.match?(/\p{Han}/) } ? :chinese : :english
    bookmark.lang = lang
    set_bookmark_favicon(bookmark, parser) unless bookmark.favicon
    if bookmark.save
      bookmark.save_favicon if bookmark.favicon
      CreateTag.call(bookmark, ExtractTag.call(bookmark).result.map(&:name), bookmark.user, false)
      InitComment.call(bookmark)
    else
      logger.error "[RemoteFetchJob] Save bookmark failed: #{bookmark.errors.full_messages.to_sentence}"
    end
  rescue LinkThumbnailer::HTTPError
    # TODO
  end

  private

  def set_bookmark_favicon(bookmark, parser)
    favicons = [
      parser.favicon,
      "#{GOOGLE_FAVICON_SERVICE}#{URI.parse(bookmark.url).host}"
    ]
    favicons.each do |favicon|
      retryed = false
      begin
        result = URI.parse(favicon).open(read_timeout: 10, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE)
        unless /html|text/i.match?(result.content_type)
          bookmark.favicon = favicon
          break
        end
      rescue OpenURI::HTTPError, Errno::ENOENT
        next if retryed
        url_parser = URI.parse(bookmark.url)
        favicon = [url_parser.scheme, "://", url_parser.host, "/favicon.ico"].join
        retryed = true
        retry
      end
    end
  end
end
