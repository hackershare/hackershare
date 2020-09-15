# frozen_string_literal: true

class Notifications::CommentMailer < ApplicationMailer
  def notify
    @bookmark = params[:comment]&.bookmark&.only_first
    @user     = params[:comment]&.user
    @record   = params[:record]
    mail(to: params[:recipient].email, subject: "You have new comment in hackershare")
  end
end
