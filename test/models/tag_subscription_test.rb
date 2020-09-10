# frozen_string_literal: true

# == Schema Information
#
# Table name: tag_subscriptions
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tag_id     :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_tag_subscriptions_on_tag_id              (tag_id)
#  index_tag_subscriptions_on_user_id             (user_id)
#  index_tag_subscriptions_on_user_id_and_tag_id  (user_id,tag_id) UNIQUE
#
require "test_helper"

class TagSubscriptionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
