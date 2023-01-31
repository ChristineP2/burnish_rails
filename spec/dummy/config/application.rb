# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
require 'burnish_rails'

module Dummy
  # Base Application Configuration
  class Application < Rails::Application
    config.load_defaults Rails::VERSION::STRING.to_f

    config.generators do |g|
      g.orm             :active_record
      g.template_engine :erb
      g.test_framework  :rspec,
                        fixtures: true,
                        view_specs: true,
                        helper_specs: false,
                        routing_specs: true,
                        controller_specs: true,
                        request_specs: true
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
