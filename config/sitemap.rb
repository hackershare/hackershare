# frozen_string_literal: true

require "sitemap_generator"
# SitemapGenerator::Interpreter.send :include, RoutingHelper
SitemapGenerator::Sitemap.create_index = :auto

SitemapGenerator::Sitemap.default_host = "https://hackershare.dev"
# SitemapGenerator::Sitemap.public_path = "public/sitemap"

SitemapGenerator::Sitemap.sitemaps_path = "sitemap/"

SitemapGenerator::Sitemap.create do
  # The path locale of english is nil
  path_locales = [nil, "en"]
  path_locales.each do |locale|
    add root_path(locale: locale), changefreq: "daily"
    add categories_path(locale: locale), changefreq: "daily"
    add users_path(locale: locale), changefreq: "daily"
    add bookmarks_path(locale: locale), changefreq: "daily"
    Bookmark.find_each do |bookmark|
      add bookmark_path(bookmark, locale: locale), lastmod: bookmark.updated_at, changefreq: "daily"
    end

    User.find_each do |user|
      add user_path(user, locale: locale), lastmod: user.updated_at, changefreq: "daily"
    end

    Tag.find_each do |tag|
      add bookmarks_path(tag: tag.name, locale: locale), changefreq: "daily"
    end

    WeeklySelection.find_each do |weekly_selection|
      add weekly_selection_path(weekly_selection, locale: locale), changefreq: "daily"
    end
  end
end

SitemapGenerator::Sitemap.ping_search_engines
