# == Schema Information
#
# Table name: likes
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  bookmark_id :bigint
#  user_id     :bigint
#
# Indexes
#
#  index_likes_on_bookmark_id              (bookmark_id)
#  index_likes_on_user_id                  (user_id)
#  index_likes_on_user_id_and_bookmark_id  (user_id,bookmark_id) UNIQUE
#
require "test_helper"

class LikeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
