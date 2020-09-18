# frozen_string_literal: true

# == Schema Information
#
# Table name: taggings
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  bookmark_id :bigint
#  tag_id      :bigint
#  user_id     :bigint
#
# Indexes
#
#  index_taggings_on_bookmark_id             (bookmark_id)
#  index_taggings_on_tag_id                  (tag_id)
#  index_taggings_on_tag_id_and_bookmark_id  (tag_id,bookmark_id) UNIQUE
#  index_taggings_on_user_id                 (user_id)
#
class Tagging < ApplicationRecord
  belongs_to :bookmark, counter_cache: :tags_count
  belongs_to :user, counter_cache: :taggings_count
  belongs_to :tag, counter_cache: :bookmarks_count

  validates :tag_id, uniqueness: { scope: :bookmark_id }

  after_create :sync_cached_tag_ids
  after_destroy :sync_cached_tag_ids

  def sync_cached_tag_ids
    bookmark.sync_cached_tag_ids
  end

  after_create_commit do
    TagNotification.with(tagging: self).deliver(tag.followers)
  end

  def notifications
    @notifications ||= Notification.where(params: { tagging: self }).where(type: "TagNotification")
  end

  before_destroy :destroy_notifications

  def destroy_notifications
    notifications.destroy_all
  end
end
