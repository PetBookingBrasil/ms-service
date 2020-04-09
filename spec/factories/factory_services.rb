FactoryBot.define do
  factory :service_invalid, class: "Service" do
  end

  factory :service do
    uuid { Faker::Internet.uuid }
    name  { Faker::Name.name }
    slug { Faker::Internet.slug }
    system_code { Faker::IDNumber.valid }

    trait :with_ancestry do
      association :ancestry, factory: :service_category
    end
    
  end
end
