FactoryBot.define do
  factory :service_price_rule do
    name { 'Porte e Pelagem' }
    service_price_variations_ids { [1, 2] }
    priority { 1 }
    application { 'PetBooking'}
  end
end
