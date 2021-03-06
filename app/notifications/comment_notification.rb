# frozen_string_literal: true

# To deliver this notification:
#
# CommentNotification.with(post: @post).deliver_later(current_user)
# CommentNotification.with(post: @post).deliver(current_user)

class CommentNotification < ApplicationNotification
  # Add your delivery methods
  #
  deliver_by :database
  deliver_by :email, mailer: "Notifications::CommentMailer", method: :notify, if: :email_notifications?
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  param :comment

  # Define helper methods to make rendering easier.
  #

  def type_name
    t(".type_name")
  end

  def user
    params[:comment]&.user
  end

  def message
    [params[:comment]&.user&.username, t(".commented"), params[:comment]&.bookmark&.title].join(" ")
  end

  def url
    bookmark_path(params[:comment]&.bookmark, n_id: record.id)
  end
end
