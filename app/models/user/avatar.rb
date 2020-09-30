# frozen_string_literal: true

class User
  module Avatar
    extend ActiveSupport::Concern

    included do
      has_one_attached :avatar
    end

    def avatar_url(size: :md)
      if !avatar_attached?
        return ["https://www.gravatar.com/avatar", Digest::MD5.hexdigest(email)].join("/")
      end

      Rails.cache.fetch([cache_key_with_version, "avatar_url", size]) do
        Rails.application.routes.url_helpers.upload_url(avatar.blob.key, s: size)
      end
    end

    def avatar_attached?
      Rails.cache.fetch([cache_key_with_version, "avatar_attached"]) do
        avatar.attached?
      end
    end
  end
end
