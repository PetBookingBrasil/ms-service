FactoryBot.define do
  factory :service_invalid, class: "Service" do
  end

  factory :service do
    uuid { Faker::Internet.uuid }
    name  { Faker::Name.name }
    slug { Faker::Internet.slug }
    system_code { Faker::IDNumber.valid }
    trait :with_anncestry do
      association :service_category, factory: :service_category
    end
  end
end
