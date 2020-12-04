# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:hover, :show, :index, :top_hackers]
  before_action :set_user, only: %i[show]

  def show
    if %w[follower_users follow_users].include?(params[:type])
      if params[:type] == "follower_users"
        @relation_users = @user.follower_users
      else
        @relation_users = @user.follow_users
      end
      respond_to do |format|
        format.js do
          render partial: "users/relation_users",
                 content_type: "text/html",
                 locals: { relation_users: @relation_users, user: @user }
        end
        format.html
      end
    else
      base = Bookmark.filter(@user, params).preload(:ref, :tags)
      base = base.tag_filter(base, params[:tag]) if params[:tag].present?
      @pagy, @bookmarks = pagy_countless(
        base.with_attached_favicon_local,
        items: 10,
        link_extra: 'data-remote="true" data-action="ajax:success->listing#replace"'
      )
      respond_to do |format|
        format.js { render partial: "users/bookmarks_with_pagination", content_type: "text/html" }
        format.html
      end
    end
  end

  def index
    @pagy, @users = pagy_countless(
      User.order(score: :desc).with_attached_avatar,
      items: 32,
      link_extra: 'data-remote="true" data-action="ajax:success->listing#replace"'
    )

    respond_to do |format|
      format.js { render partial: "users/list", content_type: "text/html" }
      format.html
    end
  end

  def top_hackers
    render partial: "top_hackers"
  end

  def hover
    @user = User.find(params[:id])
    render layout: false
  end

  def setting
    @user = current_user
  end

  def toggle_following
    @user = User.find(params[:id])
    if current_user.follow_user_ids.include?(@user.id)
      @follow = false
      current_user.follows.where(following_user: @user).first&.destroy
    else
      @follow = true
      follow = @current_user.follows.create(following_user: @user)
      FollowNotification.with(follow: follow).deliver(@user)
    end
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.json { render json: { follow: @follow, user: @user.as_json(only: %i[id followers_count]) } }
    end
  end

  def update_setting
    @user = current_user
    @user.update(params.require(:user).permit(
                   :username,
      :default_bookmark_lang,
      :about,
      :avatar,
      :homepage,
      :enable_email_notification
      )
    )
    flash[:success] = t("your_profile_updated_successfully")
    redirect_to setting_users_path
  end

  private

    def set_user
      @user = User.find(params[:id])
    end
end
