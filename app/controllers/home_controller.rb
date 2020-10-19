# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    if user_signed_in?
      render_bookmarks
    else
      render "landing", layout: "landing"
    end
  end

  def about
    render "landing", layout: "landing"
  end
end
