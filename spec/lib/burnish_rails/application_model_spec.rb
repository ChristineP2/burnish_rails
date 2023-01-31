# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(BurnishRails::ApplicationModel) do
  before do
    translated_object = Class.new(BurnishRails::ApplicationModel) do
      include BurnishRails::Translatable
    end
    stub_const('FakeModel', translated_object)
  end

  it_behaves_like 'an active record model'

  it_behaves_like 'a translatable object' do
    let(:translated_object) { FakeModel }
    let(:translation_string) { 'Model' }
    let(:scope) { :activemodel }
    let(:type) { :models }
    let(:object_name) { :fake_model }
  end
end
