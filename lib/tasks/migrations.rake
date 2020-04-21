namespace :migrations do
  desc "Migrate to Service Category"
  task :to_service_category => :environment do
    migration = Modules::ServiceCategory::Migration.new
    migration.parse_category_service
  end
end
