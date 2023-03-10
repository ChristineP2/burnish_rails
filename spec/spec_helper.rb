# frozen_string_literal: true

require 'burnish_rails'
require 'dotenv/load'
require 'simplecov'
SimpleCov.start 'rails' do
  add_filter 'spec/'
  add_filter '.github/'
  add_filter 'lib/generators/templates/'
  add_filter 'lib/burnish_rails/version'
end
# if ENV['CI'] == 'true'
#   require 'codecov'
#   SimpleCov.formatter = SimpleCov::Formatter::Codecov
# end

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each { |f| require f }
ENV['RAILS_ENV'] = 'test'
require_relative '../spec/dummy/config/environment'
ENV['RAILS_ROOT'] ||= "#{File.dirname(__FILE__)}../../../spec/dummy"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
