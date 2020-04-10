10.times do |t|
  service_category = ServiceCategory.create(
    uuid: Faker::Internet.uuid,
    name: Faker::Name.name,
    slug: Faker::Internet.slug,
    system_code: Faker::Internet.slug,
  )
  10.times do |sub|
    ServiceCategory.create(
      uuid: Faker::Internet.uuid,
      name: Faker::Name.name,
      slug: Faker::Internet.slug,
      system_code: Faker::Internet.slug,
      parent: service_category
    )
  end
end
