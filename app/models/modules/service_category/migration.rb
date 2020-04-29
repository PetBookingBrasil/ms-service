require 'json'
require 'csv'
require 'open-uri'
class Modules::ServiceCategory::Migration
  attr_accessor :api_categories, :api_category_templates, :service_categories,
                :api_service_categories_migrated, :api_service_categories_errors

  def initialize
    @service_categories = []
    @api_service_categories_migrated = []
    @api_service_categories_errors = []
    @api_categories = [
      {name: "Banho e Tosa",           position: 1, cover_image: "1530932395.png",slug: "banho-e-tosa",           html_class_name: "wash",              icon: "1541677789.png" },
      {name: "Consulta veterinária",   position: 2, cover_image: "1530932580.png",slug: "consulta-veterinaria",   html_class_name: "vet",               icon: "1541690747.png" },
      {name: "Adestramento",           position: 3, cover_image: "1530932854.png",slug: "adestramento",           html_class_name: "training",          icon: "1541690760.png" },
      {name: "Serviços 24 Horas",      position: 4, cover_image: "1530933318.png",slug: "servicos-24-horas",      html_class_name: "",                  icon: "1541690773.png" },
      {name: "Dog Walker e Pet Sitter",position: 5, cover_image: "1530933331.png",slug: "dog-walker-e-pet-sitter",html_class_name: "DogWalkerPetSitter",icon: "1541690789.png" },
      {name: "Varejonline",            position: 6, cover_image:  nil,            slug: "varejonline" ,           html_class_name: nil,                 icon: nil}
    ]
  end


  def parse_category_service
    begin
      @api_categories.each do |service_category_data|
        @service_categories << ServiceCategory.new(service_category_data)
      end
      true
    rescue => exception
      raise exception.message
    end
  end

  def save_service_categories
    parse_category_service
    if @service_categories.blank?
      puts 'Nothing to migrate'
    else
      @service_categories.each do |service_category|
        if service_category.save
          @api_service_categories_migrated << service_category
        else
          @api_service_categories_errors << service_category
        end
      end
    end
    true
  end
end
