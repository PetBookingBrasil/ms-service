FactoryBot.define do
  factory :service_category_invalid, class: "ServiceCategory" do
  end

  sequence :rand_sequence do |n|
    "rand-sequence-#{rand(1000)}-#{n}"
  end

  factory :service_category do
    uuid { generate(:rand_sequence) }
    slug { generate(:rand_sequence) }
    system_code { generate(:rand_sequence) }
    name  { "Example of Service" }
    
    trait :with_parent do
      parent { create(:service_category) }
    end
  end
end
