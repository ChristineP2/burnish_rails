# frozen_string_literal: true

require 'active_support/inflector'

module BurnishRails
  # Translatable concern automatically scopes using standard
  # rails naming convention allowing for easier use of localization.
  module Translatable
    extend ActiveSupport::Concern
    extend ActiveModel::Translation

    # The following methods are added to all objects using translatable.
    class_methods do
      def i18n_superclass
        if superclass.name == 'BurnishRails::ApplicationRecord'
          return :activerecord
        end

        :activemodel
      end

      def i18n_object_type
        if superclass.name == 'BurnishRails::ApplicationPresenter'
          return :presenters
        end

        :models
      end

      def i18n_attr_type
        :attributes
      end

      def i18n_error_type
        :errors
      end

      def i18n_object_scope
        [i18n_superclass, i18n_object_type] + namespaced_symbols
      end

      def i18n_attr_scope
        [i18n_superclass, i18n_attr_type] + namespaced_symbols
      end

      def i18n_error_scope
        [i18n_superclass, i18n_error_type] + namespaced_symbols
      end

      def namespaced_symbols
        name.split('::').map(&:underscore).map(&:to_sym)
      end

      def to_simpleform_name
        namespaced_symbols.join('_')
      end

      def human_object_name
        attribute_name = i18n_object_scope.last
        scope = i18n_object_scope - Array(i18n_object_scope.last)
        sender = :human_object_name

        i18n_translation(attribute_name, scope, sender)
      end

      def human_attribute(name)
        i18n_translation(name, i18n_attr_scope, :human_attribute)
      end

      def human_error(name)
        i18n_translation(name, i18n_error_scope, :human_error)
      end

      def human_enum(enum_name, enum_value)
        name = "#{enum_translation_key(enum_name)}.#{enum_value}"

        i18n_translation(name, i18n_attr_scope, :human_enum)
      end

      def enum_options_for_select(enum_name)
        translation_key = enum_translation_key(enum_name)
        send(translation_key).map do |key, _|
          [human_enum(enum_name, key), key]
        end
      end

      def enum_translation_key(enum_name)
        enum_name.to_s.pluralize
      end

      def i18n_translation(name, scope, sender = nil)
        str = I18n.t(name,
                     scope: scope,
                     default: '')

        return i18n_default(name, sender) if str.blank? && sender

        str
      end

      def i18n_default(name, sender)
        if i18n_object_type == 'presenters' && sender
          return reference.send(sender, name)
        end

        name.to_s.humanize.titleize
      end
    end
  end
end
