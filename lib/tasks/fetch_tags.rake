# frozen_string_literal: true

desc :fetch_github_tags

task fetch_tags: :environment do
  base_url = "https://github.com/topics?page="
  (1..100).each do |i|
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
        Tag.create!(name: attrs[:name], user: User.rss_robot, description: attrs[:desc], remote_img_url: attrs[:img])
      end
    end
  end
end
