FactoryBot.define do
  factory :service_invalid, class: "Service" do
  end

  factory :service do
    service_category
    uuid { Faker::Internet.uuid }
    name  { Faker::Name.name }
    slug { Faker::Internet.slug }
    'public' { true }

    trait :isnt_public do
      'public' { false }
    end

    trait :petbooking do
      application { 'petbooking' }
    end

    trait :amei do
      application { 'amei' }
    end
  end
end
