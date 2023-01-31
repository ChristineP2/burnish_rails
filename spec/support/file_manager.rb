# frozen_string_literal: true

require 'fileutils'
require 'rails_helper'

module Spec
  class FileManager
    CONFIG_FILE = 'config/initializers/burnish_rails.rb'
    PRESENTER_FILE = 'app/presenters/application_presenter.rb'
    ACTIVE_MODEL_FILE = 'app/models/application_model.rb'
    ACTIVE_RECORD_FILE = 'app/models/application_record.rb'
    PRESENTER_SPEC_FILE = 'spec/presenters/luster_presenter_spec.rb'
    PRESENTER_OBJECT_FILE = 'app/presenters/luster_presenter.rb'

    def initialize(type)
      @file = FileManager.const_get("#{type.upcase}_FILE")
    end

    attr_reader :file

    def origin
      Rails.root.join(file)
    end

    def backup
      Rails.root.join("#{file}.bak")
    end

    def remove
      FileUtils.mv(origin, backup) if File.file?(origin)

      FileUtils.remove_file origin if File.file?(origin)
    end

    def reset
      FileUtils.mv(backup, origin) if File.file?(backup)

      FileUtils.remove_file backup if File.file?(backup)
    end
  end
end
