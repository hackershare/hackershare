# frozen_string_literal: true

class CreateTag
  prepend SimpleCommand
  include ActiveModel::Validations

  attr_reader :bookmark, :tag_names, :user

  def initialize(bookmark, tag_names, user)
    @bookmark = bookmark
    @tag_names = tag_names
    @user = user
  end

  def call
    new_tags = tag_names.map { |x| Tag.find_or_create_by(name: x) { |t| t.user = user } }
    old_tags = bookmark.tags.where(taggings: { user: user }).to_a
    add_tags = (new_tags - old_tags)
    remove_tags = (old_tags - new_tags)
    add_tags.each { |x| bookmark.taggings.create(tag: x, user: user) }
    bookmark.taggings.where(tag: remove_tags).where(user: user).destroy_all
    bookmark.tags.where(taggings: { user: user }).reload
  end
end
