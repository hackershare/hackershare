# frozen_string_literal: true

class TagsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new]

  def new
    @bookmark = Bookmark.find(params[:bookmark_id])
    respond_to do |format|
      format.html {}
      format.js { render "new", content_type: "text/html" }
    end
  end

  def create
    @bookmark = Bookmark.find(params[:bookmark_id])
    tag_names = JSON.parse(params["basic"]).map { |x| x["value"] }
    CreateTag.call(@bookmark, tag_names, current_user)
    # TODO partial refresh
    redirect_back(fallback_location: bookmarks_path)
  end
end
