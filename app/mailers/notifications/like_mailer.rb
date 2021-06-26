# frozen_string_literal: true

class Notifications::LikeMailer < ApplicationMailer
  def notify
    @bookmark = params[:like]&.bookmark&.only_first
    @user = params[:like]&.user
    @record = params[:record]
    mail(to: params[:recipient].email, subject: "Your bookmark has a new favorite in hackershare")
  end
end
