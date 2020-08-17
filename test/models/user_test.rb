# == Schema Information
#
# Table name: users
#
#  id               :bigint           not null, primary key
#  about            :text
#  email            :string
#  extension_token  :string
#  followers_count  :integer          default(0)
#  followings_count :integer          default(0)
#  homepage         :string
#  password_digest  :string
#  remember_token   :string
#  username         :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_users_on_email               (email) UNIQUE
#  index_users_on_email_lower_unique  (lower((email)::text)) UNIQUE
#  index_users_on_remember_token      (remember_token) UNIQUE
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
