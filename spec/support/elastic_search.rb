RSpec.configure do |config|
  config.before(:suite) do
    # reindex models
    Service.reindex
    ServiceCategory.reindex

    # and disable callbacks
    Searchkick.disable_callbacks
  end

  config.around(:each, search: true) do |example|
    Searchkick.callbacks(true) do
      example.run
    end
  end
end