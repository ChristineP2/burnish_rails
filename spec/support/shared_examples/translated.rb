# frozen_string_literal: true

require 'rails_helper'

# it_behaves_like "a_translated_object"
RSpec.shared_examples('a translated object') do
  described_class.attribute_names.each do |attr|
    let(:attr) { attr }

    it "does not use the default for attribute #{attr}" do
      expect(
        described_class.send(:human_attribute_name, attr)
      ).to(eq(described_class.send(:i18n_translation, attr, translation_scope)))
    end
  end
end
