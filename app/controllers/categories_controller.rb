# frozen_string_literal: true

class CategoriesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @pagy, @tags = pagy_countless(
      Tag.preload(:user).order(bookmarks_count: :desc),
      items: 12,
      link_extra: 'data-remote="true" data-action="ajax:success->listing#replace"'
    )

    respond_to do |format|
      format.js { render partial: "categories/list", content_type: "text/html" }
      format.html
    end
  end
end
