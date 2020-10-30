# frozen_string_literal: true

class WeeklyMailer < ApplicationMailer
  def notify
    @user = params[:user]
    @bookmarks = Bookmark.original.sorting(sortby: "weekly").limit(20)
    @title = @bookmarks.find { |bookmark| bookmark.title.to_s.size > 20 }&.title || "Hackershare Weekly #{Date.today.beginning_of_week}"
    mail(to: @user.email, subject: @title) if email_notifications?(@user)
  end
end
