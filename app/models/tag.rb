# frozen_string_literal: true

# == Schema Information
#
# Table name: tags
#
#  id                  :bigint           not null, primary key
#  auto_extract        :boolean          default(TRUE)
#  bookmarks_count     :integer          default(0)
#  description         :text
#  is_rss              :boolean          default(FALSE)
#  name                :string
#  remote_img_url      :string
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
  # Update postcss.config.js together for tailwindcss purge problems
  COLORS = %w[gray red yellow green blue indigo purple pink].freeze

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

  def preferred_or_self
    preferred || self
  end

  def alias_names
    aliases.map(&:name).join(", ")
  end

  def alias_names=(text)
    # text format: [{"value":"mysql"},{"value":"Mysql"},{"value":"a"}]
    return if text.blank?
    alias_name_array = JSON.parse(text).map { |x| x["value"] }.reject { |x| x == self.name }.uniq
    new_aliases = alias_name_array.map do |alias_name|
      Tag.create_with(user: User.rss_robot).find_or_create_by(name: alias_name)
    end

    remove_aliases = aliases.to_a - new_aliases
    remove_aliases.each { |t| t.update(preferred: nil) }
    new_aliases.each { |t| t.update(preferred: self) }
    Bookmark.where("cached_tag_with_aliases_ids && ?", Util.to_pg_array(self.reload.self_with_aliases_ids)).each { |b| b.sync_cached_tag_ids }
  end

  def similar_tag_names(limit = 10)
    Tag.where("ratio(name, ?) >= 50", self.name).where("id != ?", self.id).limit(limit).map(&:name).join(",")
  end

  def self.list_names(limit)
    Tag.order(bookmarks_count: :desc).where(is_rss: false).main.limit(limit).map(&:name).join(",")
  end

  def followed_by?(user)
    return unless user
    user.follow_tag_ids.include?(self.id)
  end

  def color
    @color ||= COLORS[id % COLORS.size]
  end
end
