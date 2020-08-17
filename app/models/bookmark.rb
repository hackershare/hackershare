# == Schema Information
#
# Table name: bookmarks
#
#  id                   :bigint           not null, primary key
#  cached_like_user_ids :integer          default([]), is an Array
#  description          :text
#  dups_count           :integer          default(0)
#  favicon              :string
#  likes_count          :integer          default(0)
#  score                :integer
#  smart_score          :float
#  title                :string
#  url                  :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  ref_id               :bigint
#  user_id              :bigint
#
# Indexes
#
#  index_bookmarks_on_ref_id           (ref_id)
#  index_bookmarks_on_score            (score)
#  index_bookmarks_on_smart_score      (smart_score)
#  index_bookmarks_on_url_and_user_id  (url,user_id) UNIQUE
#  index_bookmarks_on_user_id          (user_id)
#
class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :ref, class_name: "Bookmark", optional: true, counter_cache: :dups_count
  has_many :duplications, foreign_key: :ref_id, class_name: "Bookmark"

  has_many :likes
  has_many :like_users, through: :likes, source: "user"
  has_many :bookmark_stats
  scope :original, -> { where("ref_id IS NULL") }

  validates :url, presence: true
  validates :url, url: { no_local: true }
  validates :url, uniqueness: { scope: :user }

  after_create do
    if original = Bookmark.where(url: url).where("id !=?", id).first
      BookmarkStat.incr_dups_count(original.id)
      self.ref = original
    end
  end

  after_destroy do
    Bookmark.decr_dups_count(ref.id) if ref
  end

  def liked_by?(user)
    return unless user

    cached_like_user_ids.include?(user.id)
  end

  after_create_commit do
    # RemoteFetchJob.new.perform(id)
    RemoteFetchJob.perform_now(id)
  end

  def self.sorting(params)
    dt = Date.today
    if params[:dt].blank? || !%w[daily weekly monthly all].include?(params[:dt])
      return Bookmark.order("smart_score desc")
    end
    return Bookmark.order("score desc") if params[:dt] == "all"
    if params[:dt] == "daily"
      return Bookmark.joins(:bookmark_stats).where(bookmark_stats: { date_type: :daily, date_id: dt }).order("bookmark_stats.score desc")
    end
    if params[:dt] == "weekly"
      return Bookmark.joins(:bookmark_stats).where(bookmark_stats: { date_type: :weekly, date_id: dt.beginning_of_week }).order("bookmark_stats.score desc")
    end

    if params[:dt] == "monthly"
      Bookmark.joins(:bookmark_stats).where(bookmark_stats: { date_type: :monthly, date_id: dt.beginning_of_month }).order("bookmark_stats.score desc")
    end
  end
end
