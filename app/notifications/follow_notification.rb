# frozen_string_literal: true

# To deliver this notification:
#
# FollowNotification.with(post: @post).deliver_later(current_user)
# FollowNotification.with(post: @post).deliver(current_user)

class FollowNotification < ApplicationNotification
  # Add your delivery methods
  #
  deliver_by :database
  deliver_by :email, mailer: "Notifications::FollowMailer", method: :notify, if: :email_notifications?
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  param :follow

  # Define helper methods to make rendering easier.
  #

  def type_name
    t(".type_name")
  end

  def user
    params[:follow]&.user
  end

  def message
    [params[:follow]&.user&.username, t(".followed_you")].join(" ")
  end
  #
  def url
    user_path(params[:follow]&.user, n_id: record.id)
  end
end
