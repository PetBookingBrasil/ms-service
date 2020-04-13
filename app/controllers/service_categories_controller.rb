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
    service_category = ServiceCategory.new(service_category_params)
    if service_category.save
      render json: service_category, status: 201
    else
      render json: service_category.errors , status: 400
    end    
  end

  def update
  end

  protected

    def service_category_params
      params.require(:service_category).permit(:id, :uuid, :business_id, :name, :slug, :system_code)
    end
end
