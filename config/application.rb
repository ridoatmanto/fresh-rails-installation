require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OdsApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    config.middleware.use Rack::MethodOverride

    config.cognito = config_for(:cognito).with_indifferent_access
    config.s3 = config_for(:s3).with_indifferent_access
    config.allow_origin = config_for(:allow_origin).with_indifferent_access
    config.urls = config_for(:urls)

    config.active_record.schema_format = :sql
    config.active_job.queue_adapter = :delayed_job
    config.action_mailer.delivery_method = :smtp

    ActionMailer::Base.smtp_settings = {
      address: ENV['SMTP_HOST'],
      port: ENV['SMTP_PORT'],
      user_name: ENV['SMTP_USER'],
      password: ENV['SMTP_PASS'],
      authentication: :login,
      # enable_starttls_auto: ENV['SMTP_TLS'] == 'true'
      enable_starttls_auto: true
    }

  end
end
