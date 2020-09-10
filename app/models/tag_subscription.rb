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
class TagSubscription < ApplicationRecord
  belongs_to :user, counter_cache: :follow_tags_count
  belongs_to :tag, counter_cache: :subscriptions_count
end
