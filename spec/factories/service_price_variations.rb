FactoryBot.define do
  factory :service_price_variation do
    trait :size do
      name { 'Porte' }
      variations { ['p', 'm', 'g', 'gg'] }
      kind { :simple }
      priority { 2 }
    end

    trait :coat do
      name { 'Pelagem' }
      variations { ['curta', 'média', 'longa'] }
      kind { :simple }
      priority { 3 }
    end

    trait :breed do
      name { 'Raça' }
      variations { ['p', 'm', 'g', 'gg'] }
      kind { :breed }
      priority { 1 }
    end
  end
end
