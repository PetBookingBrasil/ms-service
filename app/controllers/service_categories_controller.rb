class ServiceCategoriesController < ApplicationController
  def index
    @service_categories = ServiceCategory.without_ancestry
    render json: @service_categories
  end

  def create
  end

  def update
  end
end
