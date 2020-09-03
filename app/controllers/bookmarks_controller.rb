# frozen_string_literal: true

class BookmarksController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  def new; end

  def index
    base = Bookmark.sorting(params).original.preload(:user, :tags)
    base = Bookmark.tag_filter(base, params[:tag]) if params[:tag].present?
    @pagy, @bookmarks = pagy_countless(
      base,
      items: 10,
      link_extra: 'data-remote="true" data-action="ajax:success->listing#replace"'
    )
    respond_to do |format|
      format.js { render partial: "bookmarks/bookmarks_with_pagination", content_type: "text/html" }
      format.html
    end
  end

  def show
    @bookmark = Bookmark.find(params[:id]).only_first
    @user = @bookmark.user
  end

  def create
    @bookmark = current_user.bookmarks.new(bookmark_params)
    if @bookmark.save
      respond_to do |format|
        format.js { render @bookmark.reload, content_type: "text/html", locals: { bookmark: @bookmark.only_first, bookmark_self: @bookmark } }
        format.html do
          flash[:success] = t("bookmark_added")
          redirect_to root_path
        end
      end
    else
      flash[:error] = t("bad_url")
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
      @bookmark.likes.create(user: current_user)
    end
    render json: { like: @like, bookmark: @bookmark.as_json(only: %i[id url likes_count]) }
  end

  def bookmark_params
    params.require(:bookmark).permit(:url)
  end
end
