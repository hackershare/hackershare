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
#  tag_id       :bigint
#
class RssSource < ApplicationRecord
  validates :code, :url, presence: true, uniqueness: true
  belongs_to :tag, optional: true

  def tag_name
    name || code.humanize
  end

  def find_or_init_tag
    tag || create_tag(is_rss: true, name: tag_name, user: User.rss_bot)
  end
end
