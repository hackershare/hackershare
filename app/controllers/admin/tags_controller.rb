# frozen_string_literal: true

class Admin::TagsController < Admin::ApplicationController
  def index
    base = Tag.order(subscriptions_count: :desc).main.preload(:aliases)
    base = base.where("name ILIKE '%#{Util.escape_quote(params[:query])}%'") if params[:query].present?
    @pagy, @tags = pagy_countless(
      base,
      items: 20
    )
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.find(params[:id])
    @tag.update(params.require(:tag).permit(:name, :alias_names))
    flash[:success] = "Tag was uccessfully updated"
    redirect_to admin_tags_path
  end
end
