# frozen_string_literal: true

class Admin::UsersController < Admin::ApplicationController
  def index
    @pagy, @users = pagy_countless(
      User.order(score: :desc),
      items: 20
    )
  end
end
