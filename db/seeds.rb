10.times do
  service_category = ServiceCategory.create!(
    uuid: Faker::Internet.uuid,
    name: Faker::Name.name,
    slug: Faker::Internet.uuid,
    system_code: Faker::Internet.uuid,
    business_id: rand(1..3)
  )
  rand(10).times do
    children = ServiceCategory.create!(
      uuid: Faker::Internet.uuid,
      name: Faker::Name.name,
      slug: Faker::Internet.uuid,
      system_code: Faker::Internet.uuid,
      parent: service_category,
      business_id: rand(1..3)
    )
    rand(10).times do
      ServiceCategory.create!(
        uuid: Faker::Internet.uuid,
        name: Faker::Name.name,
        slug: Faker::Internet.uuid,
        system_code: Faker::Internet.uuid,
        parent: children,
        business_id: rand(1..3)
      )
    end
  end
end
