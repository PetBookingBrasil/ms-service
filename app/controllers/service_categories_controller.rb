class ServiceCategoriesController < ApplicationController
  def index
    # render json: ServiceCategory.roots.map{|t| { root: t.attributes, descendants: t.descendants } }
    render json: ServiceCategory.hash_tree
  end

  def create
  end

  def update
  end
end
