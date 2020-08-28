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
require "test_helper"

class AuthProviderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
