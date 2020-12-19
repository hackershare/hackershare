# frozen_string_literal: true

# == Schema Information
#
# Table name: bookmarks
#
#  id                            :bigint           not null, primary key
#  cached_like_user_ids          :integer          default([]), is an Array
#  cached_tag_ids                :bigint           default([]), is an Array
#  cached_tag_names              :string
#  cached_tag_with_aliases_ids   :bigint           default([]), is an Array
#  cached_tag_with_aliases_names :string
#  clicks_count                  :integer          default(0)
#  comments_count                :integer          default(0)
#  content                       :text
#  description                   :text
#  dups_count                    :integer          default(0)
#  excellented_at                :datetime
#  favicon                       :string
#  images                        :string           default([]), is an Array
#  is_display                    :boolean          default(TRUE), not null
#  is_excellent                  :boolean          default(FALSE), not null
#  is_rss                        :boolean          default(FALSE), not null
#  lang                          :integer          default("english"), not null
#  likes_count                   :integer          default(0)
#  score                         :integer
#  shared_at                     :datetime
#  smart_score                   :float
#  tags_count                    :integer          default(0)
#  title                         :string
#  tsv                           :tsvector
#  url                           :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  pinned_comment_id             :bigint
#  ref_id                        :bigint
#  user_id                       :bigint
#  weekly_selection_id           :bigint
#
# Indexes
#
#  boomkark_rum_tsv_idx                            (tsv) USING rum
#  idx_similar_by_tag                              (cached_tag_with_aliases_ids) USING rum
#  index_bookmarks_on_cached_tag_with_aliases_ids  (cached_tag_with_aliases_ids) USING gin
#  index_bookmarks_on_ref_id                       (ref_id)
#  index_bookmarks_on_score                        (score)
#  index_bookmarks_on_smart_score                  (smart_score)
#  index_bookmarks_on_url_and_user_id              (url,user_id) UNIQUE
#  index_bookmarks_on_user_id                      (user_id)
#
require "test_helper"

class BookmarkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
