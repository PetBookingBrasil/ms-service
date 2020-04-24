ENV["RAILS_ENV"] = 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'factory_bot'
require 'database_cleaner'

require 'slack-notifier'
require 'simplecov'
SimpleCov.start

$notifier = Slack::Notifier.new "WEBHOOK_URL"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.include FactoryBot::Syntax::Methods
  config.include RSpec::Rails::RequestExampleGroup, type: :request, file_path: /spec\/requests/

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end

end
