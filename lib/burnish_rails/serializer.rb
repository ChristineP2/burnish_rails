# encoding: utf-8
# frozen_string_literal: true

module Serializer
  class << self
    #
    # @param [Object<ActiveModel>] klass This is the presenter class to use for
    # each array item
    # @param [Hash] opts, the options to create a message with.
    # @option opts [Hash{Symbol => Array<Symbol>}] :keys, attribute sets used
    #   for specific contexts.
    #
    #   Examples:
    #     * json - the attributes in the array assigned to json will be used
    #        to generate the json representation of the presented object.
    #     * modify - the attributes in the array assigned to the modify key
    #        will be used when generating the form for editing.
    #     * show - the attributes in the array assigned to the show key will
    #         be used when displaying the presented object.

    def of(presenter, opts = { keys: {} })
      class_methods = Module.new do
        # @method #presenter_context = accessor for the presenter
        #   the serializer will use for its results.
        define_method(:presenter_context) do
          presenter
        end

        # @method #presenter_context = accessor for the keys the presenter
        #   intends to use.
        define_method(:keys) do
          keys
        end


        opts[:keys].each do |key, value|
          define_method("#{key}_keys".to_sym) do
            return value.map(&:to_sym) unless Array(value).empty?

            send(:keys)
          end
        end

        # @method #to_hash - returns hash with the column keys.
        define_method(:hashed_results) do |results|
          results.each_with_object([]) do |result, arr|
            next if result.blank?

            arr << result.to_hash.slice(*self.send(:keys))
          end
        end

        # @method #to_json - returns json hash with the json keys.
        define_method(:json_results) do |results|
          self.send(:hashed_results, results).map do |hash|
            if self.respond_to(:json_keys)
              hash.slice(*self.send(:json_keys))
            else
              hash
            end
          end.to_json
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
          results.map { |result|
            presenter.new(
              view_context: view_context,
              object: result
            )
          }
        end

        singleton_class.send(:define_method, :included) do |host_class|
          # Remember any extended class's methods will be class methods.
          host_class.extend(class_methods)
        end
      end
    end
  end
end
