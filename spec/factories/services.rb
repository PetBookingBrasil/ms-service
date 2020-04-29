FactoryBot.define do
  factory :service_invalid, class: "Service" do
  end

  factory :service do
    service_category { create(:service_category) }
    uuid { generate(:rand_sequence) }
    name  { Faker::Name.name }
    slug { generate(:rand_sequence) }
    business_id { 1 }
    application { 'varejopet' }

    trait :petbooking do
      application { 'petbooking' }
    end

    trait :amei do
      application { 'amei' }
    end

    trait :with_parent do
      parent { create(:service) }
    end
  end
end
