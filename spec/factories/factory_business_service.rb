FactoryBot.define do
  factory :business_service_invalid, class: "BusinessService" do
  end

  factory :business_service do
    service
    business_id { 1 }
    comission_percentage { 10 }
    duration { 1.hours }
    cost { 150 }
  end
end
