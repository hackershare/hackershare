class InitIsRssForTag < ActiveRecord::Migration[6.0]
  def change
    RssSource.all.each do |s|
      if tag = Tag.where(name: s.tag_name).first
        Tag.transaction do
          tag.update(is_rss: true)
          s.update(tag: tag)
        end
      end
    end
  end
end
