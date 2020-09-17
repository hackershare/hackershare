# frozen_string_literal: true

# == Schema Information
#
# Table name: rss_sources
#
#  id           :bigint           not null, primary key
#  code         :string           not null
#  limit        :integer
#  name         :string           not null
#  processed_at :datetime
#  url          :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class RssSource < ApplicationRecord
  validates :code, :url, presence: true, uniqueness: true

  def tag
    name || code.humanize
  end
end
