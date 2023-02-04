# frozen_string_literal: true

# @ since 0.1.0
# @author Christine Panus
module BurnishRails
  # Namespace for presenter classes and setup for presenter use.
  module Presenter
    class << self
      #
      # @param [Symbol] reference, method name to use for the presented object
      # @param [Symbol] abbr, abbreviation for the above reference
      # @param [Object<ActiveModel>] klass This is the presented class singleton
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

      def of(reference, abbr, klass, opts={keys: {}})
        attribute_keys = klass.new.attribute_names.map(&:to_sym)
        reflection_keys = []

        if klass.respond_to?(:reflections)
          reflection_keys = klass.reflections.keys.map(&:to_sym)
        end

        access_keys = Array(attribute_keys) + Array(reflection_keys)

        class_methods = Module.new do
          # @method #reference - access the symbol you defined as the reference
          # symbol
          define_method(:reference) do
            reference
          end

          # @method #presented_obj - access the singleton object to be presented
          define_method(:presented_obj) do
            klass
          end

          define_method(:class_as_path_string) do
            klass.name.underscore.tr('/', '_')
          end

          # @method #attribute_keys - array of attribute keys
          define_method(:attribute_keys) do
            attribute_keys.map(&:to_sym)
          end

          # @method #reflection_keys - array of associations/reflections
          define_method(:reflection_keys) do
            reflection_keys.map(&:to_sym)
          end

          # @method #accessible_keys - array of all getters available for
          # presentation
          define_method(:accessible_keys) do
            access_keys.map(&:to_sym)
          end

          opts[:keys].each do |key, value|
            define_method("#{key}_keys".to_sym) do
              return value.map(&:to_sym) unless Array(value).empty?

              send(:accessible_keys)
            end
          end

          define_method(:strong_keys) do
            return send(:permitted_keys) if respond_to?(:permitted_keys)

            send(:accessible_keys)
          end

          # Each accessible key will have a class method present
          # in the presenter to get the translated text for the
          # given label
          access_keys.each do |attr|
            define_method("label_#{attr}") do
              klass.human_attribute_name(attr)
            end
          end
        end

        Module.new do
          # These methods will be included in the instance
          # of the object.

          # @method #initialize make a new presenter and give it the
          #            view_context within which it will present information.
          #
          # @param [Hash] attributes the presenter details
          #   NOTE: view_context is required. Everything else is optional.
          #
          # @option opts [ActiveView::Base] :view_context
          # @option opts [klass] :object The instance to be presented
          # @option opts [identifier] :primary_key The key used to load the
          #                         instance. Only used if object is
          #                         nil, or not of the appropriate type.
          # @option opts [Any] ... Whatever is needed in the specific
          #                           presenter after view_context, object,
          #                           and primary_key are removed.

          define_method(:initialize) do |attributes|
            vc = attributes.fetch(:view_context)
            build_element = attributes.fetch(
              :object, attributes.fetch(
                         :primary_key, nil
                       )
            )
            object = presenting(build_element)
            instance_variable_set(:@view_context, vc)
            instance_variable_set("@#{reference}", object)
            instance_variable_set(:@params, attributes[:params])
            instance_variable_set(:@primary_key, attributes[:primary_key])

            send(:configure,
                 attributes.except(
                   :view_context,
                   :object,
                   :primary_key,
                   :params
                 ))
          end

          define_method :primary_key do
            instance_variable_get(:@primary_key)
          end
          alias_method :to_key, :primary_key

          define_method :params do
            @param_detail ||= instance_variable_get(:@params)

            @param_detail = {} if @param_detail.blank?

            @param_detail
          end

          define_method(:strong_params) do
            sf_name = self.class.presented_obj.to_simpleform_name.to_sym

            get_base = send(:params).fetch(sf_name, {})

            return self.class.default_params if get_base.blank?

            get_base.permit(
              self.class.strong_keys
            ).with_defaults(self.class.default_params)
          end

          # @method #presenting - provides an instance of the object. If it
          #     receives a value that is not the object, it assumes it can
          #     use ActiveRecord#find to load the object using the given
          #     value.
          define_method :presenting do |presented|
            return klass.new if presented.blank?

            return presented if presented.instance_of?(klass)

            # Assume the presented thing is primary key if
            # it is provided and it isn't an object of the
            # type matching the klass
            return klass.send(:find, presented) if klass.respond_to?(:find)

            klass.new
          end

          # @method #view_context - Getter for the view_context for use in
          #     the presenter.
          define_method(:view_context) do
            # FIXME: Draper & Mountain View have a solution for
            # having to send view_context in with every
            # decorator, investigate them
            instance_variable_get(:@view_context)
          end

          # @method #{reference} - This creates a method using the reference
          #   name presented, and aliases it to the abbreviation so you can
          #   work with the model object in the presenter's customization
          define_method(reference) do
            instance_variable_get("@#{reference}")
          end
          alias_method abbr.to_sym, reference.to_sym
          alias_method :to_model, reference.to_sym

          access_keys.each do |attr|
            # @method #{key}_str - pass through to the Model Object
            #   to access the unadulterated value for the accessor.
            #
            # Not actually a string, so this name might need to be changed.
            define_method("#{attr}_base") do
              send(reference).send(attr)
            end

            # @method #{key} - presentable version of the key for
            #    the given format.
            define_method(attr) do
              val = send(reference).send(attr)
              return '' if val.nil?

              val.to_s
            end

            # FIXME: Should we delegate sender or explicitly manage
            # sending to reference in a presenter instance?
            #
            # define_method("#{attr}=") do |val|
            #   self.send(reference).send("#{attr}=", val)
            # end
            # delegate assign_attributes, ...
          end

          # Remember any extended class's methods will be class methods.
          # So the methods from class_methods module are going to be
          # class methods.
          singleton_class.send(:define_method, :included) do |host_class|
            host_class.extend(class_methods)
          end
        end
      end
    end
  end
end
