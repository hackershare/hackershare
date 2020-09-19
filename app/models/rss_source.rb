# frozen_string_literal: true

# == Schema Information
#
# Table name: rss_sources
#
#  id         :bigint           not null, primary key
#  code       :string           not null
#  name       :string           not null
#  url        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tag_id     :bigint
#
class RssSource < ApplicationRecord
  validates :code, :url, presence: true, uniqueness: true
  belongs_to :tag, optional: true

  def tag_name
    name || code.humanize
  end
end
