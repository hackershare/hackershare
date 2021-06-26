require_relative "20200917081924_add_limit_to_rss_sources"

class RemoveLimitInRssSources < ActiveRecord::Migration[6.0]
  def change
    revert AddLimitToRssSources
  end
end
