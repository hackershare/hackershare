# frozen_string_literal: true

# == Schema Information
#
# Table name: rss_sources
#
#  id           :bigint           not null, primary key
#  enabled      :boolean          default(TRUE)
#  is_display   :boolean          default(TRUE), not null
#  processed_at :datetime
#  tag_name     :string           not null
#  url          :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  creator_id   :bigint           default(100), not null
#  tag_id       :bigint
#
class RssSource < ApplicationRecord
  validates :url, uniqueness: true, url: { no_local: true }
  validates :tag_name, presence: true
  belongs_to :creator, class_name: "User"
  belongs_to :tag, optional: true
end
