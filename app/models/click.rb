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
class Click < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :bookmark, counter_cache: true

  after_create :incr_stats

  def incr_stats
    BookmarkStat.incr_clicks_count(bookmark_id)
  end
end
