# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(BurnishRails::ApplicationPresenter) do
  before do
    translated_object = Class.new(BurnishRails::ApplicationPresenter) do
      include BurnishRails::Translatable
    end
    stub_const('FakePresenter', translated_object)
  end

  it_behaves_like 'an active record model'

  it_behaves_like 'a translatable object' do
    let(:translated_object) { FakePresenter }
    let(:translation_string) { 'Presenter' }
    let(:scope) { :activemodel }
    let(:type) { :presenters }
    let(:object_name) { :fake_presenter }
  end
end
