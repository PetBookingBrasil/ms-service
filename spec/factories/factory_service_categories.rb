FactoryBot.define do
  factory :service_category_invalid, class: "ServiceCategory" do
  end

  factory :service_category do
    uuid { Faker::Internet.uuid }
    name  { "Example of Service" }
    slug { Faker::Internet.uuid }
    system_code { Faker::Internet.slug }
  end
end
