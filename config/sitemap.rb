# frozen_string_literal: true

require "sitemap_generator"
# SitemapGenerator::Interpreter.send :include, RoutingHelper
SitemapGenerator::Sitemap.create_index = :auto

SitemapGenerator::Sitemap.default_host = "https://hackershare.dev"
SitemapGenerator::Sitemap.public_path = "public/sitemap"

SitemapGenerator::Sitemap.sitemaps_path = "sitemap/"

SitemapGenerator::Sitemap.create do
  add "/categories", changefreq: "daily"
  add "/users", changefreq: "daily"
  add "/bookmarks", changefreq: "daily"
  Bookmark.find_each do |bookmark|
    add bookmark_path(nil, bookmark), lastmod: bookmark.updated_at, changefreq: "daily"
  end

  User.find_each do |user|
    add user_path(nil, user), lastmod: user.updated_at, changefreq: "daily"
  end

  Tag.find_each do |tag|
    add bookmarks_path(nil, tag: tag.name), changefreq: "daily"
  end
end

SitemapGenerator::Sitemap.ping_search_engines
