# frozen_string_literal: true

class Notifications::FollowMailer < ApplicationMailer
  def notify
    @user = params[:follow]&.user
    @record = params[:record]
    mail(to: params[:recipient].email, subject: "Your have a new follower in hackershare")
  end
end
