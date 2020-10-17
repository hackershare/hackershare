# frozen_string_literal: true

class SaveGavatarJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    return if /fakemail.com/.match?(user.email)
    return if user.avatar.attached?
    img_url = ["https://www.gravatar.com/avatar", Digest::MD5.hexdigest(user.email)].join("/")
    downloaded_image = open(img_url, read_timeout: 10)
    user.avatar.attach(
      io: downloaded_image,
      filename: File.basename(URI.parse(img_url).path)
    )
  end
end
