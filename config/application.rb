require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_text/engine"
require "action_cable/engine"
require "rails/test_unit/railtie"
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MsService
  class Application < Rails::Application
    config.i18n.available_locales = ['pt-BR', :en]
    config.i18n.default_locale = :'pt-BR'
    config.i18n.fallbacks = true
    config.active_record.schema_format = :sql
    config.load_defaults 6.0
    config.api_only = true

    config.active_record.schema_format = :sql
  end
end
