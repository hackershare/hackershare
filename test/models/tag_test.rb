# frozen_string_literal: true

# == Schema Information
#
# Table name: tags
#
#  id                  :bigint           not null, primary key
#  bookmarks_count     :integer          default(0)
#  is_rss              :boolean          default(FALSE)
#  name                :string
#  subscriptions_count :integer          default(0)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_id             :bigint
#
# Indexes
#
#  index_tags_on_bookmarks_count  (bookmarks_count)
#  index_tags_on_user_id          (user_id)
#
require "test_helper"

class TagTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
