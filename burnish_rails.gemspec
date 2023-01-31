# frozen_string_literal: true

require_relative 'lib/burnish_rails/version'

Gem::Specification.new do |spec|
  spec.name        = 'burnish_rails'
  spec.version     = BurnishRails::VERSION
  spec.authors     = ['Christine Panus']
  spec.email       = ['christine.panus@panusventures.com']

  spec.summary = 'A set of presentation logic tools for Rails apps.'
  spec.description = 'Tools for Translation and Presentation of model objects.'
  spec.homepage = 'https://github.com/ChristineP2/burnish_rails'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.7.0'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set
  # the "allowed_push_host" to allow pushing to a single host or delete this
  # section to allow pushing to any host.
  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/ChristineP2/burnish_rails'
  spec.metadata['changelog_uri'] = 'https://github.com/ChristineP2/burnish_rails/blob/main/CHANGELOG.md'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  end

  spec.add_dependency 'rails', '>= 7.0.4.2'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
