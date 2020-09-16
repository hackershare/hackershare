# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/notifications/comment_mailer
class Notifications::CommentMailerPreview < ActionMailer::Preview
  def notify
    Notifications::CommentMailer.with(
      comment: Comment.last,
      recipient: User.first,
      record: Notification.last
    ).notify
  end
end
