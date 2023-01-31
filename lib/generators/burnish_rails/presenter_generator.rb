# frozen_string_literal: true

require 'rails/generators'

module BurnishRails
  module Generators
    # Installs default initializer file for BurnishRails
    class PresenterGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)
      desc 'Creates Presenter File for Model Object.'

      def create_presenter_file
        template_file = ([
          Rails.root,
          'app',
          'presenters'
        ] + class_path) << "#{file_name}_presenter.rb"
        template 'presenter.rb.erb',
                 template_file.join('/')
      end

      def create_presenter_spec
        template_file = ([
          Rails.root,
          'spec',
          'presenters'
        ] + class_path) << "#{file_name}_presenter_spec.rb"

        template 'presenter_spec.rb.erb',
                 template_file.join('/')
      end
    end
  end
end
