# frozen_string_literal: true

class WeeklyMailer < ApplicationMailer
  def notify
    user = params[:user]
    @weekly_selection = params[:weekly_selection]
    if params[:preview] || email_notifications?(user)
      locale = user.english? ? :en : :'zh-CN'
      I18n.with_locale(locale) do
        mail(to: user.email, subject: @weekly_selection.full_title)
      end
    end
  end
end
