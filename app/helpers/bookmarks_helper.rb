# frozen_string_literal: true

module BookmarksHelper
  def pretty_bookmarks_path(*args, &block)
    if user_signed_in?
      root_path(*args, &block)
    else
      bookmarks_path(*args, &block)
    end
  end
end
