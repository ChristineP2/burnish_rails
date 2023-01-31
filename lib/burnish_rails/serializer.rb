# frozen_string_literal: true

# @ since 0.1.0
# @author Christine Panus

require 'rails/all'

module BurnishRails
  # Namespace for serializer classes and setup for serializer use.
  module Serializer
    class << self
      #
      # @param [Symbol] presenter, what presenter will be the context for
      #   the individual records presented by the serializer.
      # @param [Hash] opts, the options to create a message with.
      # @option opts [Hash{Symbol => Array<Symbol>}] :keys, attribute sets used
      #   for specific contexts.
      #
      #   Examples:
      #     * all - all keys of interest for the presenter. (if no more
      #             specific key-set specified, this will be used)
      #     * json - the specific presenter keys used for the json result set.
      #     * html - the specific presenter keys used for the html result set.
      #     * any custom key...

      def of(presenter, options)
        @opts = options
        class_methods = Module.new do
          # @method #presenter_context = accessor for the presenter
          #   the serializer will use for its results.
          define_method(:presenter_context) do
            presenter
          end

          # @method #presenter_context = accessor for the keys the presenter
          #   intends to use.
          define_method(:presenter_keys) do
            return default_keys if default_keys.length.positive?

            presenter.send(:accessible_keys)
          end

          custom_keys.each do |key, value|
            define_method("#{key}_keys") do
              return value if Array(value).length.positive?

              send(:presenter_keys)
            end
          end

          # @method #to_hash - returns hash with the keys.
          define_method(:presenter_results) do |results|
            results.each_with_object([]) do |result, arr|
              next if result.blank?

              arr << result.to_hash.slice(*send(:presenter_keys))
            end
          end

          custom_keys.each do |key, _value|
            define_method("#{key}_results") do |results|
              send(:presenter_results, results).map do |hash|
                hash.slice(*send("#{key}_keys".to_sym))
              end
            end

            define_method("#{key}_to_json") do |results|
              send("#{key}_keys".to_sym, results).to_json
            end
          end

          # @method #label_#{key} = delegator from the serializer to the
          #    presented object for the labels used to present the results
          #
          #   (can override)

          keys.map do |name|
            delegate = "label_#{name}".to_sym
            define_method(delegate) do
              presenter.send(delegate)
            end
          end
        end

        Module.new do
          # These methods will be included in the instance
          # of the object

          # @method #make_presentable = wraps each item in the result within a
          #   presenter for the specific result object
          define_method(:make_presentable) do |results|
            results.map do |result|
              presenter.new(
                view_context: view_context,
                object: result
              )
            end
          end

          singleton_class.send(:define_method, :included) do |host_class|
            # Remember any extended class's methods will be class methods.
            host_class.extend(class_methods)
          end
        end
      end

      attr_reader :opts

      private

      def default_keys
        Array(keys[:all])
      end

      def custom_keys
        keys.except(:all)
      end

      def keys
        opts[:keys]
      end
    end
  end
end
