# frozen_string_literal: true

desc :fetch_github_tags

task fetch_tags: :environment do
  base_url = "https://github.com/topics?page="
  (1..).each do |i|
    url = base_url + i.to_s
    html = open(url).read
    doc = Nokogiri::HTML(html)
    list = doc.css("li.py-4.border-bottom")
    break if list.blank?
    list.each do |li|
      attrs = {
        name: li.css("p.f3.link-gray-dark").text,
        desc: li.css("p.f5.text-gray").text.strip,
        img: li.css("img.rounded-1")&.attribute("src")&.value
      }
      if tag = Tag.where("lower(name) = ?", attrs[:name].downcase).first
        tag = tag.preferred_or_self
        tag.update(description: attrs[:desc], remote_img_url: attrs[:img])
      else
        tag = Tag.create!(name: attrs[:name], user: User.rss_robot, description: attrs[:desc], remote_img_url: attrs[:img])
      end
      tag.update(auto_extract: false) if tag && (tag.name.size < 3 || tag.name.size > 15)
    end
  end
end

desc "fetch tag from stackshare"
task fetch_tags_from_stackshare: :environment do
  base_url = "https://stackshare.io/tools/top?page="
  (1..).each do |i|
    url = base_url + i.to_s
    html = open(url).read
    doc = Nokogiri::HTML(html)
    list = doc.css("#trending-box")
    break if list.blank?
    list.each do |li|
      attrs = {
        name: li.css("#service-name-trending").text,
        desc: li.css(".trending-description").text.strip,
        img: li.css(".tool-logo img")&.attribute("src")&.value
      }
      if tag = Tag.where("lower(name) = ?", attrs[:name].downcase).first
        tag = tag.preferred_or_self
        tag.update(description: attrs[:desc], remote_img_url: attrs[:img]) if tag.remote_img_url.blank?
      else
        tag = Tag.create!(name: attrs[:name], user: User.rss_robot, description: attrs[:desc], remote_img_url: attrs[:img])
      end
      tag.update(auto_extract: false) if tag && (tag.name.size < 3 || tag.name.size > 10)
    end
  end
end
