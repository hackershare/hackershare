class SaveAvatarJob < ApplicationJob
  queue_as :default

  def perform(provider_id)
    provider  = AuthProvider.find(provider_id)
    provider.save_img 
  end
end
