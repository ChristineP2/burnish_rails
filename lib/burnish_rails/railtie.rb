# frozen_string_literal: true

require 'rails/railtie'

module BurnishRails
  class Railtie < ::Rails::Railtie
    initializer "burnish_rails_railtie.configure_rails_initialization" do
      # Inspired by https://jeremydye.fyi/2022/06/18/adding-a-custom-generator-to-rails-scaffold/
      module BurnishRails
        module ScaffoldGenerator
          extend ActiveSupport::Concern

          included do
            hook_for :presenter, in: nil, default: true, type: :boolean
          end
        end
      end

      module ActiveModel
        class Railtie < Rails::Railtie
          generators do |app|
            Rails::Generators.configure! app.config.generators
            Rails::Generators::ScaffoldGenerator.include BurnishRails::ScaffoldGenerator
          end
        end
      end
    end

    generators do |app|
      Rails::Generators.configure! app.config.generators
      require 'generators/burnish_rails/install_generator'
      require 'generators/burnish_rails/presenter_generator'
    end
  end
end
