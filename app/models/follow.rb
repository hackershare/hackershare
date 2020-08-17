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
class Follow < ApplicationRecord
  belongs_to :user, counter_cache: :followings_count
  belongs_to :following_user, counter_cache: :followers_count, class_name: "User"
end
