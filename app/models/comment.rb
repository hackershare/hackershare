# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id          :bigint           not null, primary key
#  comment     :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  bookmark_id :bigint
#  user_id     :bigint
#
# Indexes
#
#  index_comments_on_bookmark_id  (bookmark_id)
#  index_comments_on_user_id      (user_id)
#
class Comment < ApplicationRecord
  belongs_to :user, counter_cache: true
  belongs_to :bookmark, counter_cache: true
  validates :comment, presence: true
end
