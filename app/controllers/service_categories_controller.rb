class ServiceCategoriesController < ApplicationController
  def index
    render json: ServiceCategory.arrange_serializable
  end

  def search
    render json: ServiceCategory.search(params[:search])
  end

  def create
  end

  def update
  end
end
