# frozen_string_literal: true

class Admin::TagsController < Admin::ApplicationController
  def index
    @pagy, @tags = pagy_countless(
      Tag.order(subscriptions_count: :desc).main.preload(:aliases),
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
