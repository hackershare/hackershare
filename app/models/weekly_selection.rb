# frozen_string_literal: true

# == Schema Information
#
# Table name: weekly_selections
#
#  id              :bigint           not null, primary key
#  bookmarks_count :integer          default(0)
#  description     :text
#  description_en  :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class WeeklySelection < ApplicationRecord
  has_many :bookmarks
end
