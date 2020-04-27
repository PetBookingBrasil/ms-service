FactoryBot.define do
  factory :business_service_price do
    business_service_id { 1 }
    price { 10.00 }
    service_price_combination
  end
end
