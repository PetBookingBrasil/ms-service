FactoryBot.define do
  factory :service_category_invalid, class: "ServiceCategory" do
  end

  factory :service_category do
    uuid { Faker::Internet.uuid }
    name  { "Example of Service" }
    slug { "example-of-service" }
    system_code { "code-0001" }

    factory :service_category_with_ancestry, class: "ServiceCategory" do
      association :ancestry, factory: :service_category
      slug { Faker::Internet.slug }
      system_code { Faker::IDNumber.valid }
      after(:build) do |service|
        service.ancestry ||= create(:service_category)
      end
    end
    
  end
end
