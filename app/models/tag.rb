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
#  preferred_id        :bigint
#  user_id             :bigint
#
# Indexes
#
#  index_tags_on_bookmarks_count      (bookmarks_count)
#  index_tags_on_subscriptions_count  (subscriptions_count)
#  index_tags_on_user_id              (user_id)
#
class Tag < ApplicationRecord
  belongs_to :user, counter_cache: true
  has_one :rss_source
  has_many :taggings
  has_many :bookmarks, through: :taggings

  has_many :tag_subscriptions
  has_many :followers, through: :tag_subscriptions, source: "user"

  has_many :aliases, foreign_key: :preferred_id, class_name: "Tag"
  belongs_to :preferred, class_name: "Tag", optional: true

  scope :main, -> { where(preferred_id: nil) }

  validates :name, uniqueness: true

  def self_with_aliases_ids
    if is_alias?
      [preferred.id, preferred.aliases.map(&:id)].flatten.uniq
    else
      [id, aliases.map(&:id)].flatten.uniq
    end
  end

  def is_alias?
    preferred.present?
  end

  def self.list_names(limit)
    Tag.order(bookmarks_count: :desc).where(is_rss: false).main.limit(limit).map(&:name).join(",")
  end

  def followed_by?(user)
    return unless user
    user.follow_tag_ids.include?(self.id)
  end
end
