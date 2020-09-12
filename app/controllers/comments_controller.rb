# frozen_string_literal: true

class CommentsController < ApplicationController
  def create
    @bookmark = Bookmark.find(params[:bookmark_id])
    @comment = @bookmark.comments.new(comment: params[:comment], user: current_user)
    if @comment.save
      CommentNotification.with(comment: @comment).deliver([@bookmark.user, @bookmark.comments.map { |x| x.user }].flatten.uniq - [current_user])
      respond_to do |format|
        format.js { render @comment, content_type: "text/html" }
        format.html do
          flash[:success] = t("comment_added")
          redirect_to bookmark_path(@bookmark)
        end
      end
    else
      flash[:error] = t("bad_comment")
      redirect_to bookmark_path(@bookmark)
    end
  end
end
