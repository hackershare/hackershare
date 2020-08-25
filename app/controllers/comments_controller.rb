class CommentsController < ApplicationController
  def create
    @bookmark = Bookmark.find(params[:bookmark_id])
    @comment = @bookmark.comments.new(comment: params[:comment], user: current_user)
    if @comment.save
      respond_to do |format|
        format.js { render @comment, content_type: "text/html" }
        format.html do
          flash[:success] = "comment added."
          redirect_to bookmark_path(@bookmark)
        end
      end
    else
      flash[:error] = "Bad comment"
      redirect_to bookmark_path(@bookmark)
    end
  end
end
