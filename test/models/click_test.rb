# frozen_string_literal: true

# == Schema Information
#
# Table name: clicks
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  bookmark_id :bigint
#  user_id     :bigint
#
# Indexes
#
#  index_clicks_on_bookmark_id              (bookmark_id)
#  index_clicks_on_user_id                  (user_id)
#  index_clicks_on_user_id_and_bookmark_id  (user_id,bookmark_id)
#
require "test_helper"

class ClickTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
