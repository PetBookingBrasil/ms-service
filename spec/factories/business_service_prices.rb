FactoryBot.define do
  factory :business_service_price do
    business_service
    price { 10.00 }
    service_price_combination
  end
end
