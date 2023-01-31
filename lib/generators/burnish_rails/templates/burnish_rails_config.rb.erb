# frozen_string_literal: true

require "rails/railtie"
require "rails/generators"
require "rails/generators/rails/scaffold_controller/scaffold_controller_generator"
require 'burnish_rails'

BurnishRails.config do |config|
  # You may override the default config/locales
  # config.locales_path = true

  # If you want to use simple_form, set this true.
  # config.simple_form = true

  # If you want to use will_paginate, set this true.
  # config.will_paginate = true
end

module BurnishRails
  module Generators
    module ScaffoldControllerGenerator
      extend ActiveSupport::Concern

      included do
        hook_for :presenter, in: nil, default: true, type: :boolean
      end
    end
  end
end

module ActiveModel
  class Railtie < Rails::Railtie
    generators do |app|
      Rails::Generators.configure! app.config.generators
      Rails::Generators::ScaffoldControllerGenerator.include BurnishRails::Generators::ScaffoldControllerGenerator
    end
  end
end
