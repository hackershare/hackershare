# frozen_string_literal: true

# == Schema Information
#
# Table name: weekly_selections
#
#  id              :bigint           not null, primary key
#  bookmarks_count :integer          default(0)
#  description     :text
#  description_en  :text
#  published_at    :datetime
#  title           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class WeeklySelection < ApplicationRecord
  BOOKMARKS_COUNT = 5
  has_many :bookmarks
  validates :title, :description, :description_en, presence: true, if: :published?
  scope :unpublished, lambda { where(published_at: nil) }
  scope :published, lambda { where.not(published_at: nil) }

  def published?
    published_at.present?
  end

  def guessed_title
    bookmarks.select(&:weekly_selection_title?).sort_by(&:smart_score).last&.title
  end

  def full_title
    "#{title} | #{I18n.t("issue_no", no: id)}"
  end
end
