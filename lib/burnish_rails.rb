# frozen_string_literal: true

require_relative 'burnish_rails/railtie' if defined?(Rails::Railtie)
require_relative 'burnish_rails/version'
require_relative 'burnish_rails/presenter'
require_relative 'burnish_rails/serializer'
require_relative 'burnish_rails/application_model'
require_relative 'burnish_rails/application_presenter'
require_relative 'burnish_rails/application_record'
require_relative 'burnish_rails/translatable'

# Adds separation of concerns and OO standards for the frontend while
# also making translation easier.
module BurnishRails
  class << self
    # Required Config - None
    # attr_accessor :required1

    # Optional Config
    attr_writer :locales_path, :simple_form, :will_paginate

    def config
      yield self
    end

    def will_paginate
      @will_paginate || false
    end

    def locales_path
      @locales_path || "#{Rails.root}/config/locales"
    end

    def simple_form
      @locales_path || false
    end
  end
  class Error < StandardError; end
  # Your code goes here...
end
