require 'rails_helper'

RSpec.describe Modules::ServiceCategory::Migration do
  subject { Modules::ServiceCategory::Migration.new }

  describe "Read the URL JSON" do
    before do
      subject.api_category_templates_url = Rails.root.join('spec','support','dataclips','category_templates.csv')
    end
    context "success scenario" do
      it "initialize the service categories" do
        expect(subject.service_categories).to have(0).items
      end

      it "parse csv data to service category" do
        expect(subject.parse_category_service).to be_truthy
      end

    end
  end

end
