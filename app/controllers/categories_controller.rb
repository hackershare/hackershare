# frozen_string_literal: true

class CategoriesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    base = Tag.main.preload(:user).order(subscriptions_count: :desc)
    base = base.where(is_rss: true) if params[:is_rss].present?
    @pagy, @tags = pagy_countless(
      base,
      items: 12,
      link_extra: 'data-remote="true" data-action="ajax:success->listing#replace"'
    )

    respond_to do |format|
      format.js { render partial: "categories/list", content_type: "text/html" }
      format.html
    end
  end

  def toggle_following
    @tag = Tag.find(params[:id])
    if current_user.follow_tag_ids.include?(@tag.id)
      current_user.tag_subscriptions.where(tag: @tag).first&.destroy
    else
      @current_user.tag_subscriptions.create(tag: @tag)
    end
    current_user.reload
    render partial: "categories/follow_button", locals: { tag: @tag, user: current_user }
  end

  def toggle_subscribe
    tag = Tag.find(params[:id])
    if current_user.follow_tag_ids.include?(tag.id)
      current_user.tag_subscriptions.where(tag: tag).first&.destroy
    else
      current_user.tag_subscriptions.create(tag: tag)
    end
    @followed_tags = current_user.follow_tags.order(bookmarks_count: :desc)
    @unfollowed_tags = Tag.order(bookmarks_count: :desc).where.not(is_rss: true, id: @followed_tags.pluck(:id)).limit(10)
    render partial: "bookmarks/tag_subscribe_container", locals: { followed_tags: @followed_tags, unfollowed_tags: @unfollowed_tags }
  end
end
