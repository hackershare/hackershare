# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id               :bigint           not null, primary key
#  about            :text
#  bookmarks_count  :integer          default(0)
#  comments_count   :integer          default(0)
#  email            :string
#  extension_token  :string
#  followers_count  :integer          default(0)
#  followings_count :integer          default(0)
#  homepage         :string
#  password_digest  :string
#  remember_token   :string
#  score            :integer
#  taggings_count   :integer          default(0)
#  tags_count       :integer          default(0)
#  username         :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_users_on_email               (email) UNIQUE
#  index_users_on_email_lower_unique  (lower((email)::text)) UNIQUE
#  index_users_on_remember_token      (remember_token) UNIQUE
#  index_users_on_score               (score)
#  index_users_on_updated_at          (updated_at)
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
