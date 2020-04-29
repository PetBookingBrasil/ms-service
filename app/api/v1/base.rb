module V1
  class Base < Grape::API
    mount V1::ServiceCategories
    mount V1::Services
    mount V1::ServicePriceRules
  end
end
