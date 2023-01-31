# frozen_string_literal: true

require 'rails_helper'
require 'support/file_manager'
require 'generators/burnish_rails/install/install_generator'

RSpec.describe BurnishRails::Generators::InstallGenerator do
  let(:config) { Spec::FileManager.new('CONFIG') }
  let(:present) { Spec::FileManager.new('PRESENTER') }
  let(:am) { Spec::FileManager.new('ACTIVE_MODEL') }
  let(:ar) { Spec::FileManager.new('ACTIVE_RECORD') }

  before do
    config.remove
    present.remove
    am.remove
    ar.remove
  end

  after do
    config.reset
    present.reset
    am.reset
    ar.reset
  end

  it 'adds config file properly' do
    described_class.start

    expect(File.file?(config.origin)).to be true
  end

  it 'adds application presenter' do
    described_class.start

    expect(File.file?(present.origin)).to be true
  end

  it 'adds application model' do
    described_class.start

    expect(File.file?(am.origin)).to be true
  end

  it 'adds application record' do
    described_class.start

    expect(File.file?(ar.origin)).to be true
  end
end
