10.times do |t|
  service_category = ServiceCategory.create(
    uuid: Faker::Internet.uuid,
    name: Faker::Name.name,
    slug: Faker::Internet.slug,
    system_code: Faker::Internet.slug,
  )
  rand(10).times do 
    sub_service_category = ServiceCategory.create(
      uuid: Faker::Internet.uuid,
      name: Faker::Name.name,
      slug: Faker::Internet.slug,
      system_code: Faker::Internet.slug,
      parent: service_category
    )
    rand(20).times do
      ServiceCategory.create(
        uuid: Faker::Internet.uuid,
        name: Faker::Name.name,
        slug: Faker::Internet.slug,
        system_code: Faker::Internet.slug,
        parent: sub_service_category
      )
    end
  end
end
