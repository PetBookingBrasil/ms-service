10.times do
  service_category = ServiceCategory.create!(
    name: Faker::Name.name,
    slug: Faker::Internet.uuid,
    system_code: Faker::Internet.uuid,
    business_id: rand(1..3)
  )
  rand(5).times do
    service = Service.create!(
      service_category: service_category,
      uuid: Faker::Internet.uuid,
      name: Faker::Name.name,
      slug: Faker::Internet.uuid,
      application: service_category.name,
      business_id: rand(1..3)
    )
    Service.create!(
      parent: service,
      service_category: service_category,
      uuid: Faker::Internet.uuid,
      name: Faker::Name.name,
      slug: Faker::Internet.uuid,
      application: service_category.name,
      business_id: rand(1..3)
    )
  end
  rand(10).times do
    children = ServiceCategory.create!(
      name: Faker::Name.name,
      slug: Faker::Internet.uuid,
      system_code: Faker::Internet.uuid,
      parent: service_category,
      business_id: rand(1..3)
    )
    service = Service.create!(
      service_category: children,
      uuid: Faker::Internet.uuid,
      name: Faker::Name.name,
      slug: Faker::Internet.uuid,
      application: children.name,
      business_id: rand(1..3)
    )
    Service.create!(
      parent: service,
      service_category: children,
      uuid: Faker::Internet.uuid,
      name: Faker::Name.name,
      slug: Faker::Internet.uuid,
      application: children.name,
      business_id: rand(1..3)
    )
    rand(10).times do
      ServiceCategory.create!(
        name: Faker::Name.name,
        slug: Faker::Internet.uuid,
        system_code: Faker::Internet.uuid,
        parent: children,
        business_id: rand(1..3)
      )
    end
  end
end

ServiceCategory.reindex
Service.reindex
