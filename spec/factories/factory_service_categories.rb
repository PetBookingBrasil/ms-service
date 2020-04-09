FactoryBot.define do
  factory :service_category_invalid, class: "ServiceCategory" do
  end

  factory :service_category do
    uuid { Faker::Internet.uuid }
    name  { "Example of Service" }
    slug { Faker::Internet.slug }
    system_code { Faker::IDNumber.valid }

    trait :with_ancestry do
      association :ancestry, factory: :service_category
    end
    
  end
end
