# frozen_string_literal: true

# TODO: Implement Testing, see https://stackoverflow.com/a/27871495/8174080

require 'active_record/base'
require 'burnish_rails/translatable'

# @ since 0.1.0
# @author Christine Panus
module BurnishRails
  class ApplicationRecord < ActiveRecord::Base
    include BurnishRails::Translatable
  end
end
