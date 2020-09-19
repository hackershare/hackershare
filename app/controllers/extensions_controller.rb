# frozen_string_literal: true

class ExtensionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    bookmark = current_user.bookmarks.create(url: params[:url])
    UserFeedNotification.with(bookmark: bookmark).deliver(current_user.follower_users)
    render json: bookmark.reload.attributes.merge(location: Rails.application.routes.url_helpers.bookmark_url(nil, bookmark)).to_json
  end
end
