class CategoriesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
end
