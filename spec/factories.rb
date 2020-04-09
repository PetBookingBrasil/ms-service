FactoryBot.define do
  factory :service_category_invalid, class: "ServiceCategory" do
  end

  factory :service_category do
    uuid { Faker::Internet.uuid }
    name  { "Example of Service" }
    slug { "example-of-service" }
    system_code { "code-0001" }
  end

  factory :service_category_with_ancestry, class: "ServiceCategory" do
    uuid { Faker::Internet.uuid }
    name  { "Example of Service Ancestry" }
    slug { "example-of-service-ancestry" }
    system_code { "code-0002" }
    association :ancestry, factory: :service_category

    after(:build) do |service|
      service.ancestry ||= create(:service_category)
    end
  end
end
