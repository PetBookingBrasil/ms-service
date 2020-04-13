class ServiceCategoriesController < ApplicationController
  def index
    render json: ServiceCategory.arrange_serializable
  end

  def filter
    results = []
    if params[:business_id]
      results = ServiceCategory.where(business_id: params[:business_id].split('|'))
    end

    render json: results 
  end

  def create
  end

  def update
  end
end
