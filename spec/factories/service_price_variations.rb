FactoryBot.define do
  factory :service_price_variation do
    trait :size do
      service_price_rule
      name { 'Porte' }
      variations { ['p', 'm', 'g', 'gg'] }
      kind { :simple }
      priority { 2 }
    end

    trait :coat do
      service_price_rule
      name { 'Pelagem' }
      variations { ['curta', 'média', 'longa'] }
      kind { :simple }
      priority { 3 }
    end

    trait :breed do
      service_price_rule
      name { 'Raça' }
      variations { ['p', 'm', 'g', 'gg'] }
      kind { :breed }
      priority { 1 }
    end
  end
end
