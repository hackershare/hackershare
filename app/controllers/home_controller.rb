class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  layout :home_layout

  def index
    if user_signed_in?
      query = Util.escape_quote(params[:query]) if params[:query]
      base = Bookmark.sorting(params).original.preload(:user, :tags)
      base = base.tag_filter(base, params[:tag]) if params[:tag].present?
      base = base.where(lang: params[:bookmark_lang]) if params[:bookmark_lang].in?(Bookmark.langs.keys)
      if params[:query].present?
        base = base.where("bookmarks.tsv @@ plainto_tsquery('simple', E'#{query}')")
        base = base.select("bookmarks.*, ts_rank_cd(bookmarks.tsv, plainto_tsquery('simple', E'#{query}')) AS relevance")
        base = base.order("relevance DESC")
      end
      @pagy, @bookmarks = pagy_countless(
        base,
        items: 10,
        link_extra: 'data-remote="true" data-action="ajax:success->listing#replace"'
      )
      respond_to do |format|
        format.js { render partial: "bookmarks/bookmarks_with_pagination", content_type: "text/html" }
        format.html { render 'bookmarks/index' }
      end
    else
      render 'landing'
    end
  end

  private

    def home_layout
      "landing" unless user_signed_in?
    end
end
