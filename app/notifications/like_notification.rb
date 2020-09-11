# frozen_string_literal: true

# To deliver this notification:
#
# LikeNotification.with(post: @post).deliver_later(current_user)
# LikeNotification.with(post: @post).deliver(current_user)

class LikeNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  param :like

  # Define helper methods to make rendering easier.
  #

  def type_name
    t(".type_name")
  end

  def user
    params[:like]&.user
  end

  def message
    [params[:like]&.user&.username, t(".liked_your_bookmark"), params[:like]&.bookmark&.title].join(" ")
  end
  #
  def url
    bookmark_path(nil, params[:like]&.bookmark, n_id: record.id)
  end
end
