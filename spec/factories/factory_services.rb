FactoryBot.define do
  factory :service_invalid, class: "Service" do
  end

  factory :service do
    service_category { create(:service_category) }
    uuid { Faker::Internet.uuid }
    name  { Faker::Name.name }
    slug { Faker::Internet.slug }
    business_id { 1 }
    application { 'varejopet' }

    trait :petbooking do
      application { 'petbooking' }
    end

    trait :amei do
      application { 'amei' }
    end
  end
end
