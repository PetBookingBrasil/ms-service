RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

FactoryBot.define do
  sequence :rand_sequence do |n|
    "rand-sequence-#{rand(1000)}-#{n}"
  end
  sequence :service_category_id_sequence do |n|
    n
  end
end
