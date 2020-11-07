# frozen_string_literal: true

class WeeklyMailer < ApplicationMailer
  def notify
    user = params[:user]
    @weekly_selection = params[:weekly_selection]
    if params[:preview] || email_notifications?(user)
      mail(to: user.email, subject: @weekly_selection.full_title)
    end
  end
end
