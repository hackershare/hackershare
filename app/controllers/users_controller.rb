class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:hover]

  def show
    @user = User.find(params[:id])
    limit = ({ weekly: 2, monthly: 3, all: 4, daily: 1 }[params[:dt].to_sym] if params[:dt])
    @pagy, @bookmarks = pagy_countless(
      @user.bookmarks.original.order("id desc"),
      items: limit || 10,
      link_extra: 'data-remote="true" data-action="ajax:success->listing#replace"'
    )
    respond_to do |format|
      format.js { render partial: "bookmarks/bookmarks_with_pagination", content_type: "text/html" }
      format.html
    end
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
      @current_user.follows.create(following_user: @user)
    end
    render json: { follow: @follow, user: @user.as_json(only: %i[id followers_count]) }
  end

  def update_setting
    @user = current_user
    @user.update(params.require(:user).permit(:username, :about, :avatar, :homepage))
    flash[:success] = "Your profile updated successfully."
    redirect_to setting_user_path
  end
end
