class ServiceCategoriesController < ApplicationController
  def index
    render json: ServiceCategory.hash_tree
  end

  def create
  end

  def update
  end
end
