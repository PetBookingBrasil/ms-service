require 'json'
require 'csv'
require 'open-uri'
class Modules::ServiceCategory::Migration
  attr_accessor :api_category_templates_url, :api_category_templates, :service_categories

  def initialize
    @service_categories = []
    @api_category_templates_url = 'https://data.heroku.com/dataclips/cqbcqtbwimdrchvqyhvfurqygzgf.csv?access-token=0e7031b1-4093-4a50-a01f-802bfbbe0eb0'
  end


  def parse_category_service
    begin
      # response = Net::HTTP.get_response(URI.parse(source))
      # JSON.parse(@api_category_templates_url.to_s) do |row|
      #   puts row
      # end
      # CSV.parse(File.open(@api_category_templates_url.to_s)).each_with_index do |data, line|
      #   next if line == 0
      #   @category_services << ServiceCategory.new(uuid: data[0], name: data[1], slug: data[4])
      # end


      CSV.foreach(open(@api_category_templates_url), col_sep: ",", headers: true, header_converters: :symbol) do |row|
        @service_categories << ServiceCategory.new(uuid: row[:id], name: row[:name], slug: row[:slug])
      end
    rescue => exception
      raise exception.message
    end

    def save_service_categories
      if @service_categories.blank?
        puts 'Nothing to migrate'
      else
        @service_categories.each do |service_category|
          if service_category.save
            puts "#{service_category.name}: uuid ==> #{service_category.uuid} migrated"
          else
            puts "error to migrate #{service_category.name}: uuid ==> #{service_category.uuid}:"
            puts service_category.errors.messages.to_sentence
          end
          puts "=================================================="
        end
      end
    end
  end
end
