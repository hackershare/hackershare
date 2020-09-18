# frozen_string_literal: true

class TagNotification < ApplicationNotification
  # Add your delivery methods
  #
  deliver_by :database
  # not email notify feed, too noisy
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  param :tagging

  def type_name
    t(".type_name")
  end

  def user
    params[:tagging]&.user
  end

  def tag
    params[:tagging].tag
  end

  def message
    [params[:tagging]&.tag&.name, t(".have_a_new_item"), params[:tagging]&.bookmark&.title_or_url].join(" ")
  end
  #
  def url
    bookmark_path(params[:tagging]&.bookmark&.only_first, n_id: record.id)
  end
end
