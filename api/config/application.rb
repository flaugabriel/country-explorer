# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CnabApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.time_zone = 'La Paz'
    config.active_record.default_timezone = :local
    Time::DATE_FORMATS[:default] = '%d/%m/%Y %H:%M'
    Date::DATE_FORMATS[:default] = '%d/%m/%Y'
    config.paths.add(Rails.root.join('lib').to_s, eager_load: true)
    config.autoload_paths += %W[#{config.root}/lib]
    config.api_only = true
    config.i18n.default_locale = :'pt-BR'
    config.session_store :cookie_store, key: '_interslice_session'
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use config.session_store, config.session_options
  end
end
