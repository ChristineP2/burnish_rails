# frozen_string_literal: true

require 'bundler/setup'
require 'bundler/gem_tasks'

Dir.glob(File.join('lib/tasks/**/*.rake')).each { |file| load file }

task default: %i[
  rubocop
  spec
  brakeman:check
  bundle:audit
]
