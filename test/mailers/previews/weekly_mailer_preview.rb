# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/weekly_mailer/notify
class WeeklyMailerPreview < ActionMailer::Preview
  def notify
    WeeklyMailer.with(
      user: User.last,
      weekly_selection: WeeklySelection.last,
      preview: true,
    ).notify
  end
end
