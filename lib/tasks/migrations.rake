namespace :migrations do
  desc "Migrate API data to Service Category"
  task :to_service_category => :environment do
    migration = Modules::ServiceCategory::Migration.new
    migration.parse_category_service
    # migration.save_service_categories
  end
end
