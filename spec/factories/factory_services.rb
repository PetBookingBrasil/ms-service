FactoryBot.define do
  factory :service_invalid, class: "Service" do
  end

  factory :service do
    uuid { Faker::Internet.uuid }
    name  { Faker::Name.name }
    slug { Faker::Internet.slug }
    system_code { Faker::IDNumber.valid }

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
