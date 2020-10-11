# frozen_string_literal: true

class Admin::ApplicationController < ApplicationController
  layout "admin"
  before_action :require_admin

  rescue_from "Pagy::OverflowError" do |e|
    flash[:error] = t("page_overflow")
    redirect_back fallback_location: admin_root_path
  end

  def require_admin
    redirect_to new_session_path unless current_user.admin?
  end
end
