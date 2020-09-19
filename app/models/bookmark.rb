# frozen_string_literal: true

# == Schema Information
#
# Table name: bookmarks
#
#  id                   :bigint           not null, primary key
#  cached_like_user_ids :integer          default([]), is an Array
#  cached_tag_ids       :bigint           default([]), is an Array
#  cached_tag_names     :string
#  clicks_count         :integer          default(0)
#  comments_count       :integer          default(0)
#  content              :text
#  description          :text
#  dups_count           :integer          default(0)
#  favicon              :string
#  is_rss               :boolean          default(FALSE), not null
#  lang                 :integer          default("english"), not null
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
class Bookmark < ApplicationRecord
  has_one_attached :favicon_local
  belongs_to :user, counter_cache: true, touch: true
  belongs_to :ref, class_name: "Bookmark", optional: true, counter_cache: :dups_count
  has_many :duplications, foreign_key: :ref_id, class_name: "Bookmark"

  has_many :likes, dependent: :destroy
  has_many :like_users, through: :likes, source: "user"

  has_many :comments
  scope :original, -> { where("ref_id IS NULL") }

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  has_many :clicks, dependent: :destroy
  has_many :click_users, through: :clicks, source: "user"

  has_many :bookmark_stats, dependent: :destroy

  validates :url, presence: true
  validates :url, url: { no_local: true }
  validates :url, uniqueness: { scope: :user }

  enum lang: {
    english: 0,
    chinese: 1,
  }

  def title_or_url
    title.presence || url
  end

  after_create do
    if original = Bookmark.where(url: url).where("id !=?", id).first
      BookmarkStat.incr_dups_count(original.id)
      self.update!(ref: original)
      original.touch(:created_at)
    end
  end

  after_destroy do
    BookmarkStat.decr_dups_count(ref.id) if ref
  end

  def do_destroy!
    if duplications.blank?
      self.destroy
    else
      if new_root = duplications.first
        Bookmark.transaction do
          new_root.likes.destroy_all
          new_root.bookmark_stats.destroy_all
          likes.update(bookmark: new_root)
          comments.update(bookmark: new_root)
          bookmark_stats.update(bookmark: new_root)
          duplications.where("id != ?", new_root.id).update(ref: new_root)
          new_root.update!(ref: nil)
          new_root.sync_cached_like_user_ids
          self.destroy!
        end
      end
    end
    self
  end

  def liked_by?(user)
    return unless user

    cached_like_user_ids.include?(user.id)
  end

  def created_by?(user)
    return unless user
    user_id == user.id
  end

  def can_destroy_by?(user)
    return unless user
    created_by?(user) || user.admin?
  end

  def only_first
    ref || self
  end

  def letter_char
    URI.parse(url).host.split(".")[-2..-1][0][0].upcase
  end

  def tag_names_for(user)
    return [] if user.blank?
    tags.where(taggings: { user: user }).map { |tag| tag.name }
  end

  def sync_cached_like_user_ids
    update(cached_like_user_ids: reload.like_user_ids)
  end

  def sync_cached_tag_ids
    last_tags = tags.reload
    update(cached_tag_ids: last_tags.map(&:id), cached_tag_names: last_tags.map(&:name).join(", "))
  end

  def save_favicon
    downloaded_image = open(favicon, read_timeout: 10)
    favicon_local.attach(
      io: downloaded_image,
      filename: File.basename(URI.parse(favicon).path)
    )
  end

  after_create_commit do
    # RemoteFetchJob.new.perform(id)
    RemoteFetchJob.perform_later(id)
  end

  def self.sorting(params)
    dt = Date.today

    if params[:sortby].blank? || !%w[daily weekly monthly all].include?(params[:sortby])
      return Bookmark.order("smart_score desc")
    end

    if params[:sortby] == "all"
      return Bookmark.order("score desc")
    end

    if params[:sortby] == "daily"
      return Bookmark.joins("LEFT JOIN bookmark_stats ON bookmarks.id = bookmark_stats.bookmark_id AND date_type = 'daily' AND date_id = '#{dt}'").order("bookmark_stats.score desc nulls last")
    end

    if params[:sortby] == "weekly"
      return Bookmark.joins("LEFT JOIN bookmark_stats on bookmarks.id = bookmark_stats.bookmark_id AND date_type = 'weekly' AND date_id = '#{dt.beginning_of_week}'").order("bookmark_stats.score desc nulls last")
    end

    if params[:sortby] == "monthly"
      Bookmark.joins("LEFT JOIN bookmark_stats on bookmarks.id = bookmark_stats.bookmark_id AND date_type = 'monthly' AND date_id = '#{dt.beginning_of_month}'").order("bookmark_stats.score desc nulls last")
    end
  end

  def self.tag_filter(scope, tag_name)
    tag = Tag.find_by!(name: tag_name)
    scope.joins(:taggings).where(taggings: { tag_id: tag.id })
  end

  def self.filter(user, params)
    return user.bookmarks.order(created_at: :desc) if !%w[created likes followings subscriptions].include?(params[:type])
    if params[:type] == "created"
      return user.bookmarks.order(created_at: :desc)
    end

    if params[:type] == "likes"
      return user.like_bookmarks.order(created_at: :desc)
    end

    if params[:type] == "subscriptions"
      tag_ids = user.follow_tag_ids
      return Bookmark.joins(:tags).where(tags: { id: tag_ids }).distinct.original.order(id: :desc)
    end

    if params[:type] == "followings"
      Bookmark.joins("INNER JOIN follows ON follows.following_user_id = bookmarks.user_id").where(follows: { user_id: user.id }).order(created_at: :desc)
    end
  end

  def notifications
    @notifications ||= Notification.where(params: { bookmark: self }).where(type: "UserFeedNotification")
  end

  before_destroy :destroy_notifications

  def destroy_notifications
    notifications.destroy_all
  end
end
