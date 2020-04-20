require 'json'
require 'csv'
require 'open-uri'
require 'net/http'
class Modules::ServiceCategory::Migration
  attr_accessor :api_category_templates_url, :api_category_templates, :category_services

  def initialize
    @category_services = []
    @api_category_templates_url = 'https://data.heroku.com/dataclips/mfvrqenkzekurblkekdhjkwsibfy.csv'
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


      CSV.foreach(@api_category_templates_url, headers: true, header_converters: :symbol) do |row|
        @category_services << ServiceCategory.new(uuid: row[:id], name: row[:name], slug: row[:slug])
        # puts row.to_h[:id]
        # puts row.to_h[:name]
        # puts row.to_h[:position]
        # puts row.to_h[:slug]
        # id,name,position,cover_image,slug
        # puts row
      end
      puts @category_services.inspect
    rescue => exception
      raise exception.message
    end
  end
end
