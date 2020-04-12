rand(10).times do
  service_category = ServiceCategory.create(
    uuid: Faker::Internet.uuid,
    name: Faker::Name.name,
    slug: Faker::Internet.slug,
    system_code: Faker::Internet.slug,
  )
  rand(10).times do
    children = ServiceCategory.create(
      uuid: Faker::Internet.uuid,
      name: Faker::Name.name,
      slug: Faker::Internet.slug,
      system_code: Faker::Internet.slug,
      parent: service_category
    )
    rand(10).times do
      ServiceCategory.create(
        uuid: Faker::Internet.uuid,
        name: Faker::Name.name,
        slug: Faker::Internet.slug,
        system_code: Faker::Internet.slug,
        parent: children
      )
    end
  end
end
