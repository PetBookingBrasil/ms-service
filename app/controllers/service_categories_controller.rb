class ServiceCategoriesController < ApplicationController
  def index
    @service_types = ServiceCategory.without_ancestry
    render json(@service_types)
  end

  def create
  end

  def update
  end
end
