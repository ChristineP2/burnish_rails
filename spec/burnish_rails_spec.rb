# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BurnishRails do
  it 'has a version number' do
    expect(BurnishRails::VERSION).not_to be_nil
  end

  describe 'configuration' do
    let(:subject) { class_double(described_class) }

    it 'is possible to provide options' do
      described_class.config do |c|
        expect(c).to eq(described_class)
      end
    end
  end
end
