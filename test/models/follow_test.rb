# frozen_string_literal: true

# == Schema Information
#
# Table name: follows
#
#  id                :bigint           not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  following_user_id :bigint
#  user_id           :bigint
#
# Indexes
#
#  index_follows_on_user_id_and_following_user_id  (user_id,following_user_id) UNIQUE
#
require "test_helper"

class FollowTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
