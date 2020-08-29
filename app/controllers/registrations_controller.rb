# frozen_string_literal: true

class RegistrationsController < ApplicationController
  layout "auth"
  skip_before_action :authenticate_user!

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      cookies[:remember_token_v2] = {
        value: @user.remember_token,
        expires: 1.year.from_now.utc
      }
      redirect_to root_path
    else
      flash[:error] = t("sign_up_failed")
      render :new
    end
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
