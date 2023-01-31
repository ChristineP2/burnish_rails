# frozen_string_literal: true

# TODO: Implement Testing, see https://stackoverflow.com/a/27871495/8174080

require 'active_model/railtie'
require 'burnish_rails/translatable'

# @ since 0.1.0
# @author Christine Panus

# TODO: Refactor to create narrowly focused objects
module BurnishRails
  # Add behaviors to presenter
  class ApplicationPresenter
    include ActiveModel::API
    include ActiveModel::Attributes
    include BurnishRails::Translatable

    class << self
      # FIXME: Make these into config objects, maybe?
      def paging_limit; end

      def default_params; end

      def form_field_options; end

      def data_table_options; end

      def server_side_paging?
        false
      end

      def max_results
        100
      end
    end

    def configure(*args, **kws, &block); end

    def to_s
      self.class.human_presenter_name
    end

    # Delegation to singleton methods
    def human_attribute_name(attr)
      # See if Presenter has a label
      label = self.class.human_attribute_name(attr)

      return label if label.present?

      # Try Model if presenter didn't give results
      label = ref.class.human_attribute_name(attr)

      return label if label.present?

      self.class.default_attribute_name(attr)
    end

    def no_results
      I18n.t('messages.no_results')
    end

    def results
      return @results if @results.present?

      @results = if self.class.server_side_paging?
                   make_presentable(results_paginated)
                 else
                   make_presentable(results_base)
                 end
    end

    def results_json
      @results_json ||= if no_results?
                          JSON.parse(no_results)
                        else
                          JSON.parse(results_base)
                        end
    end

    def results_paginated
      @results_paginated ||= results_base.limit(self.class.paging_limit).page(page_param)
    end

    def data_tables_opts
      return {} unless respond_to?(:data_tables_options)

      self.class.data_tables_options
    end

    # FIXME: Consider Split off into a params_presenter that will manage params
    # from view_context automagically and then move all strong parameter logic
    # into the presenter? Maybe?
    def default_params
      return {} unless self.class.respond_to?(:default_params)

      self.class.default_params
    end

    def default_param_keys
      send(:default_params).keys
    end

    # WillPaginate Support
    def page_param
      return 1 if params.blank?

      page = params.permit(:page)[:page].to_i

      return 1 if page.blank? || page.zero?

      page
    end

    # FIXME: Split off a link_presenter that is returned by
    # application presenter
    def class_as_path_string
      self.class.class_as_path_string
    end

    def index_path
      view_context.send("new_#{class_as_path_string.pluralize}_path")
    end

    def new_path
      view_context.send("new_#{class_as_path_string}_path")
    end

    def list_path
      view_context.send("#{class_as_path_string.pluralize}_path")
    end

    def show_path(id)
      view_context.send("#{class_as_path_string}_path", id)
    end

    def edit_path(id)
      view_context.send("edit_#{class_as_path_string}_path", id)
    end

    def destroy_path(id)
      view_context.send("destroy_#{class_as_path_string}_path", id)
    end

    def ref
      send(self.class.reference)
    end

    # FIXME: Split off a form_presenter that is returned by
    # application presenter
    def errors
      error_array = ref&.send(:errors)&.send(:errors)

      return unless error_array.is_a?(Array)

      error_array.each_with_object({}) do |error_obj, hsh|
        hsh[error_obj.attribute] = error_obj.message
      end
    end

    delegate :save, to: :reference

    def params
      @params ||= default_params
    end

    def field_opts(key)
      return {} unless self.class.respond_to?(:form_field_options)
      return {} unless self.class.form_field_options.key?(key)

      self.class.form_field_options[key].except(:association)
    end

    private

    def convert_str_date(month, day, year)
      return unless [*1..12].include?(month)
      return unless [*1..31].include?(day)
      return unless year > 1900

      DateTime.new(year, month, day)
    end

    def dated(val, format = :default)
      return I18n.l(val.in_time_zone, format: format) if Date.parsable?(val)

      val
    end

    def date_timed(val, format = :default)
      return I18n.l(val.in_time_zone, format: format) if Date.parsable?(val)

      val
    end

    def linked(obj, label = nil)
      return view_context.link_to(obj, obj) if label.blank?

      view_context.link_to(label, obj)
    end
  end
end
