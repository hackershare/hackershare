# frozen_string_literal: true

# To deliver this notification:
#
# UserFeedNotification.with(post: @post).deliver_later(current_user)
# UserFeedNotification.with(post: @post).deliver(current_user)

class UserFeedNotification < ApplicationNotification
  # Add your delivery methods
  #
  deliver_by :database
  # not email notify feed, too noisy
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  param :bookmark

  # Define helper methods to make rendering easier.
  #

  def type_name
    t(".type_name")
  end

  def user
    params[:bookmark]&.user
  end

  def message
    [params[:bookmark]&.user&.username, t(".shared"), params[:bookmark]&.title].join(" ")
  end

  def url
    bookmark_path(params[:bookmark]&.only_first, n_id: record.id)
  end
end
