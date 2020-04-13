class ServiceCategoriesController < ApplicationController
  before_action :set_service_category, only: [:update]
  
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
    if @service_category.update(service_category_params)
      render json: @service_category, status: 200
    else
      render json: @service_category.errors , status: 400
    end
  end

  protected

    def service_category_params
      params.require(:service_category).permit(:uuid, :business_id, :name, :slug, :system_code)
    end

    def set_service_category
      @service_category ||= ServiceCategory.find(params[:id])
    end
end
