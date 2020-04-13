class ServiceCategoriesController < ApplicationController
  def index
    render json: ServiceCategory.arrange_serializable
  end

  def filter
    render json: ServiceCategory.where(business_id: params[:business_id])
  end

  def create
  end

  def update
  end
end
