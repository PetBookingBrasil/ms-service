class ServiceCategoriesController < ApplicationController
  def index
    render json: ServiceCategory.arrange_serializable
  end

  def create
  end

  def update
  end
end
