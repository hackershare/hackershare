class RemoteFetchJob < ApplicationJob
  queue_as :default

  def perform(bookmark_id)
    bookmark = Bookmark.find(bookmark_id)
    parser = LinkThumbnailer.generate(bookmark.url)
    bookmark.update(favicon: parser.favicon, description: parser.description, title: parser.title)
  rescue LinkThumbnailer::HTTPError
    # TODO
  end
end
