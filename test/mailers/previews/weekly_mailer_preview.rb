# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/notifications/comment_mailer
class WeeklyMailerPreview < ActionMailer::Preview
  def notify
    WeeklyMailer.with(
      user: User.last,
    ).notify
  end
end
