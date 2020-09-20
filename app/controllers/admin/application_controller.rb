# frozen_string_literal: true

class Admin::ApplicationController < ApplicationController
  layout "admin"

  before_action :require_admin

  def require_admin
    redirect_to new_session_path unless current_user.admin?
  end
end
