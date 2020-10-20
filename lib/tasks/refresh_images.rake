# frozen_string_literal: true

desc "refresh bookmark images"
task refresh_images: :environment do
  Bookmark.order("id desc").original.find_each do |bookmark|
    next if bookmark.images.present?
    result = LinkThumbnailer.generate(bookmark.url)
    next if result.images.blank?
    bookmark.update(images: result.images.sort_by { |x| -(x.size[0].to_i) }).map(&:src)
  rescue
  end
end
