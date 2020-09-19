# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                        :bigint           not null, primary key
#  about                     :text
#  admin                     :boolean          default(FALSE)
#  bookmarks_count           :integer          default(0)
#  comments_count            :integer          default(0)
#  default_bookmark_lang     :integer          default("all_lang"), not null
#  email                     :string
#  enable_email_notification :boolean          default(TRUE)
#  extension_token           :string
#  follow_tags_count         :integer          default(0)
#  followers_count           :integer          default(0)
#  followings_count          :integer          default(0)
#  homepage                  :string
#  password_digest           :string
#  remember_token            :string
#  score                     :integer
#  taggings_count            :integer          default(0)
#  tags_count                :integer          default(0)
#  username                  :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
# Indexes
#
#  index_users_on_email               (email) UNIQUE
#  index_users_on_email_lower_unique  (lower((email)::text)) UNIQUE
#  index_users_on_remember_token      (remember_token) UNIQUE
#  index_users_on_score               (score)
#  index_users_on_updated_at          (updated_at)
#
class User < ApplicationRecord
  RSS_BOT_NAME  = "hackershare"
  RSS_BOT_EMAIL = "robot@hackershare.dev"
  has_secure_password
  has_one_attached :avatar
  has_many :auth_providers, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_bookmarks, through: :likes, source: "bookmark"
  has_many :follows, dependent: :destroy
  has_many :follow_users, through: :follows, source: "following_user"
  has_many :comments, dependent: :destroy
  has_many :taggings
  has_many :tags

  has_many :clicks
  has_many :click_bookmarks, through: :clicks, source: "bookmark"

  has_many :tag_subscriptions
  has_many :follow_tags, through: :tag_subscriptions, class_name: "Tag", source: "tag"

  has_many :followers, class_name: "Follow", foreign_key: "following_user_id"
  has_many :follower_users, through: :followers, source: "user"

  has_many :notifications, as: :recipient

  validates_format_of :email, with: /\A[^@\s]+@[^@\s]+\z/
  validates :email, uniqueness: true

  before_create { generate_token(:remember_token) }
  before_create { generate_token(:extension_token) }

  enum default_bookmark_lang: {
    all_lang:            0,
    follow_website_lang: 1,
  }

  def bookmark_lang
    locales_lang = {
      en: "english",
      cn: "chinese",
    }
    follow_website_lang? ? locales_lang[I18n.locale] : "language"
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.hex(32)
    end while User.exists?(column => self[column])
  end

  attr_accessor :remember_me

  has_many :bookmarks, dependent: :destroy

  def remember_me
    true
  end

  def username
    read_attribute(:username) || email.split("@")[0]
  end

  def avatar_url
    if avatar.attached?
      avatar.variant(resize_to_limit: [150, nil])
    else
      ["https://www.gravatar.com/avatar", Digest::MD5.hexdigest(email)].join("/")
    end
  end

  def has_unread_notifications?
    !!notifications.unread.order(created_at: :desc).first
  end

  def followed_by?(user)
    return unless user

    user.follows.where(following_user: self).exists?
  end

  def self.rss_robot
    @rss_robot ||= User.find_by!(username: RSS_BOT_NAME)
  end

  def self.email_or_fake(auth)
    auth["info"]["email"] || [auth["uid"], "fakemail.com"].join("@")
  end

  def self.find_or_create_from_auth(auth)
    auth_provider = AuthProvider.find_or_initialize_by(provider: auth["provider"], uid: auth["uid"])
    if auth_provider.new_record?
      auth_provider.data = auth
      if user = User.where("lower(email) = ?", email_or_fake(auth).downcase).first
        auth_provider.user = user
        auth_provider.save
      else
        user = auth_provider.build_user(
          email: email_or_fake(auth),
          username: auth["info"]["nickname"],
          password: SecureRandom.hex,
          about: auth_provider.description,
          homepage: auth_provider.homepage
        )
        auth_provider.save
      end
    else
      user = auth_provider.user
    end
    user
  end
end
