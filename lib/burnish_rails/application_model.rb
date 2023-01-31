# frozen_string_literal: true

# TODO: Implement Testing, see https://stackoverflow.com/a/27871495/8174080

require 'active_model/railtie'
require 'burnish_rails/translatable'

# @ since 0.1.0
# @author Christine Panus

module BurnishRails
  # Add basic functionality to non-database models
  class ApplicationModel
    include ActiveModel::API
    include ActiveModel::Attributes
    include BurnishRails::Translatable
  end
end
