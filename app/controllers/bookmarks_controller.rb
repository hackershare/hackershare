# frozen_string_literal: true

class BookmarksController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show hover_like_users goto]

  def index
    render_bookmarks
  end

  def show
    @bookmark = Bookmark.find(params[:id]).only_first
    @comments = @bookmark.comments.order(id: :asc)
    @user = @bookmark.user
    @similar_bookmarks = SimilarByTag.call(@bookmark).result
  end

  def goto
    # https://developers.google.com/search/reference/robots_meta_tag#using-the-x-robots-tag-http-header
    headers["X-Robots-Tag"] = "none"
    @bookmark = Bookmark.find(params[:id]).only_first
    @bookmark.clicks.create(user: current_user) unless DeviceDetector.new(request.user_agent).bot?
    redirect_to @bookmark.url
  end

  def create
    @bookmark = current_user.bookmarks.new(bookmark_params)
    if @bookmark.save
      UserFeedNotification.with(bookmark: @bookmark).deliver(current_user.follower_users)

      respond_to do |format|
        # format.js { render @bookmark.reload, content_type: "text/html", locals: { bookmark: @bookmark.only_first, bookmark_self: @bookmark } }
        format.html do
          flash[:success] = t("bookmark_added")
          redirect_to root_path
        end
      end
    else
      flash[:error] = @bookmark.errors.full_messages.to_sentence
      redirect_to root_path
    end
  end

  def destroy
    if current_user.admin?
      @bookmark = Bookmark.find(params[:id])
    else
      @bookmark = current_user.bookmarks.find(params[:id])
    end
    @bookmark.do_destroy!
    if @bookmark.destroyed?
      flash[:success] = t("bookmark_destroy_ok")
    else
      flash[:error] = t("bookmark_destroy_fail")
    end
    render js: "Turbolinks.visit(window.location);"
  end

  def toggle_liking
    @bookmark = Bookmark.find(params[:id])
    if @bookmark.like_user_ids.include?(current_user.id)
      @like = false
      @bookmark.likes.where(user: current_user).first&.destroy
    else
      @like = true
      like = @bookmark.likes.create(user: current_user)
      LikeNotification.with(like: like).deliver(@bookmark.user)
    end
    render json: { like: @like, bookmark: @bookmark.as_json(only: %i[id url likes_count]) }
  end

  def hover_like_users
    @bookmark = Bookmark.find(params[:id])
    @users = @bookmark.like_users
    render layout: false
  end

  def set_excellent
    @bookmark = authorize Bookmark.find(params[:id])
    if @bookmark.is_excellent?
      @bookmark.update!(is_excellent: false, excellented_at: nil)
    else
      @bookmark.update!(is_excellent: true, excellented_at: Time.current)
    end
    flash[:success] = "Set excellent successfully."
    redirect_back fallback_location: root_path
  rescue ActiveRecord::RecordInvalid => e
    flash[:error] = e.message
    redirect_back fallback_location: root_path
  end

  def priority_excellent
    @bookmark = authorize Bookmark.find(params[:id])
    max_priority = Bookmark.weekly_selecting.maximum(:excellented_priority) || 0
    @bookmark.update!(excellented_priority: max_priority + 1)
    flash[:success] = "Priority selection successfully."
    redirect_back fallback_location: root_path
  end

  private

    def bookmark_params
      params.require(:bookmark).permit(:url)
    end
end
