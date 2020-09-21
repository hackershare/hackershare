# frozen_string_literal: true

class Admin::TagsController < Admin::ApplicationController
  def index
    @pagy, @tags = pagy_countless(
      Tag.order(subscriptions_count: :desc),
      items: 20
    )
  end
end
