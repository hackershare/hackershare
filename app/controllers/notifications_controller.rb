# frozen_string_literal: true

class NotificationsController < ApplicationController
  def index
    @pagy, @notifications = pagy_countless(
      current_user.notifications.order(id: :desc),
      items: 10,
      link_extra: 'data-remote="true" data-action="ajax:success->listing#replace"'
    )

    respond_to do |format|
      format.js { render partial: "notifications/list", content_type: "text/html" }
      format.html
    end
  end
end
