# frozen_string_literal: true

# == Schema Information
#
# Table name: auth_providers
#
#  id         :bigint           not null, primary key
#  data       :jsonb
#  provider   :string
#  uid        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_auth_providers_on_provider_and_uid  (provider,uid) UNIQUE
#  index_auth_providers_on_user_id           (user_id)
#
class AuthProvider < ApplicationRecord
  belongs_to :user

  after_create do
    user.homepage = homepage if user.homepage.blank?
    user.about = description if user.about.blank?
    user.save
    SaveAvatarJob.perform_later(self.id) unless user.avatar.attached?
  end

  def description
    if provider == "github"
      data["extra"]["raw_info"]["bio"]
    elsif provider == "twitter"
      data["info"]["description"]
    end
  end

  def homepage
    if provider == "github"
      data["extra"]["raw_info"]["html_url"]
    elsif provider == "twitter"
      data["info"]["urls"]["Twitter"]
    end
  end

  def avatar
    if provider == "github"
      data["info"]["image"]
    elsif provider == "twitter"
      data["info"]["image"]
    end
  end

  def save_img
    downloaded_image = open(avatar)
    user.avatar.attach(
      io: downloaded_image,
      filename: File.basename(URI.parse(avatar).path)
    )
  end
end
