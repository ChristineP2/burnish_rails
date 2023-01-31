# frozen_string_literal: true

require 'rails/generators'

# https://api.rubyonrails.org/classes/Rails/Generators/Base.html

module BurnishRails
  module Generators
    # Installs default initializer file for BurnishRails
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)
      desc 'Creates BurnishRails config and presenter files.'
      def copy_config
        template 'burnish_rails_config.rb.erb',
                 "#{Rails.root}/config/initializers/burnish_rails.rb"
      end

      def presenter_setup
        template 'application_presenter.rb.erb',
                 "#{Rails.root}/app/presenters/application_presenter.rb"
      end

      def active_model_setup
        template 'application_model.rb.erb',
                 "#{Rails.root}/app/models/application_model.rb"
      end

      def active_record_setup
        template 'application_record.rb.erb',
                 "#{Rails.root}/app/models/application_record.rb"
      end
    end
  end
end
