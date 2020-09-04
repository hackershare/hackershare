# frozen_string_literal: true

# == Schema Information
#
# Table name: bookmarks
#
#  id                   :bigint           not null, primary key
#  cached_like_user_ids :integer          default([]), is an Array
#  cached_tag_ids       :bigint           default([]), is an Array
#  cached_tag_names     :string
#  comments_count       :integer          default(0)
#  content              :text
#  description          :text
#  dups_count           :integer          default(0)
#  favicon              :string
#  likes_count          :integer          default(0)
#  score                :integer
#  smart_score          :float
#  tags_count           :integer          default(0)
#  title                :string
#  tsv                  :tsvector
#  url                  :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  ref_id               :bigint
#  user_id              :bigint
#
# Indexes
#
#  fulltext_idx                        (tsv) USING gin
#  index_bookmarks_on_ref_id           (ref_id)
#  index_bookmarks_on_score            (score)
#  index_bookmarks_on_smart_score      (smart_score)
#  index_bookmarks_on_url_and_user_id  (url,user_id) UNIQUE
#  index_bookmarks_on_user_id          (user_id)
#
require "test_helper"

class BookmarkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
