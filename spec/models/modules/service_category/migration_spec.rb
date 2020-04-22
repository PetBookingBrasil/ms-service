require 'rails_helper'

RSpec.describe Modules::ServiceCategory::Migration do
  subject { Modules::ServiceCategory::Migration.new }

  describe "Read the URL JSON" do
    context "success scenario" do
      it "initialize the service categories" do
        expect(subject.service_categories).to have(0).items
      end

      it "parse csv data to service category" do
        expect(subject.parse_category_service).to be_truthy
      end

      it "save data" do
        expect(subject.save_service_categories).to be_truthy
        expect(subject.api_service_categories_migrated).to have(6).items
      end
    end

    context "error scenario" do
      it "try save when have wrong params" do
        subject.api_categories = [{}]
        subject.save_service_categories
        expect(subject.api_service_categories_errors).to have(1).items
      end
    end
  end

end
