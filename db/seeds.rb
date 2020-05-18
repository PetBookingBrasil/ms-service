10.times do
  service_category = ServiceCategory.create!(
    name: Faker::Name.name,
    slug: Faker::Internet.id,
    business_id: rand(1..3)
  )
  rand(5).times do
    service = Service.create!(
      service_category: service_category,
      id: Faker::Internet.id,
      name: Faker::Name.name,
      slug: Faker::Internet.id,
      application: service_category.name,
      business_id: rand(1..3)
    )
    Service.create!(
      parent: service,
      service_category: service_category,
      id: Faker::Internet.id,
      name: Faker::Name.name,
      slug: Faker::Internet.id,
      application: service_category.name,
      business_id: rand(1..3)
    )
  end
  rand(10).times do
    children = ServiceCategory.create!(
      name: Faker::Name.name,
      slug: Faker::Internet.id,
      parent: service_category,
      business_id: rand(1..3)
    )
    service = Service.create!(
      service_category: children,
      id: Faker::Internet.id,
      name: Faker::Name.name,
      slug: Faker::Internet.id,
      application: children.name,
      business_id: rand(1..3)
    )
    Service.create!(
      parent: service,
      service_category: children,
      id: Faker::Internet.id,
      name: Faker::Name.name,
      slug: Faker::Internet.id,
      application: children.name,
      business_id: rand(1..3)
    )
    rand(10).times do
      ServiceCategory.create!(
        name: Faker::Name.name,
        slug: Faker::Internet.id,
        parent: children,
        business_id: rand(1..3)
      )
    end
  end
end

ServiceCategory.reindex
Service.reindex
