# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  layout :home_layout

  def index
    if user_signed_in?
      render_bookmarks
    else
      render "landing"
    end
  end

  private

    def home_layout
      "landing" unless user_signed_in?
    end
end
