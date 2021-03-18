# frozen_string_literal: true

class SaveAvatarJob < ApplicationJob
  queue_as :critical

  def perform(provider_id)
    provider = AuthProvider.find(provider_id)
    provider.save_img
  end
end
