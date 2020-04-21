require 'faker'
FactoryBot.define do
  factory :service_category_invalid, class: "ServiceCategory" do
  end

  factory :service_category do
    # uuid { generate(:service_category_id_sequence) }
    sequence(:uuid) {|n| n }
    slug { generate(:rand_sequence) }
    system_code { generate(:rand_sequence) }
    business_id { 1 }
    name  { Faker::Name.name }

    trait :with_parent do
      parent { create(:service_category) }
    end
  end
end
