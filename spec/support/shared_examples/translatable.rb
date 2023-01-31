# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples('a translatable object') do
  def load_test_yaml(translations)
    yaml_string = YAML.dump(translations)

    I18n.backend.store_translations(
      :en,
      YAML.safe_load(yaml_string, permitted_classes: [Symbol])[:en]
    )
  end

  describe 'because it is translatable' do
    before do
      I18n.backend.store_translations(:en, {})
    end

    after do
      I18n.backend.reload!
    end

    it 'includes the correct translatable concern' do
      expect(described_class.included_modules).to(
        include(BurnishRails::Translatable)
      )
    end

    describe '#i18n_object_scope' do
      it 'returns the correct scope' do
        expect(translated_object.i18n_object_scope)
          .to(
            eq([scope, type, object_name])
          )
      end
    end

    describe '#i18n_attr_scope' do
      it 'returns the correct scope' do
        expect(translated_object.i18n_attr_scope)
          .to(
            eq([scope, :attributes, object_name])
          )
      end
    end

    describe '#i18n_error_scope' do
      it 'returns the correct scope' do
        expect(translated_object.i18n_error_scope)
          .to(
            eq([scope, :errors, object_name])
          )
      end
    end

    describe '#namespaced_symbols' do
      it 'returns the correct symbols' do
        expect(translated_object.namespaced_symbols)
          .to(
            eq([object_name])
          )
      end
    end

    describe '#to_simpleform_name' do
      it 'returns the correct string' do
        expect(translated_object.to_simpleform_name)
          .to(
            eq(object_name.to_s)
          )
      end
    end

    context 'when using translations' do
      before do
        translations = {
          en: {
            activemodel: {
              presenters: {
                fake_presenter: 'Presenter Name'
              },
              models: {
                fake_model: 'Model Name'
              },
              attributes: {
                fake_model: {
                  attribute_name: 'Model Attr Name'
                },
                fake_presenter: {
                  attribute_name: 'Presenter Attr Name'
                }
              },
              errors: {
                fake_model: {
                  error_name: 'Model Validation Error Name'
                },
                fake_presenter: {
                  error_name: 'Presenter Validation Error Name'
                }
              }
            },
            activerecord: {
              models: {
                fake_active_record: 'Active Record Name'
              },
              attributes: {
                fake_active_record: {
                  attribute_name: 'Active Record Attr Name'
                }
              },
              errors: {
                fake_active_record: {
                  error_name: 'Active Record Validation Error Name'
                }
              }
            }
          }
        }

        load_test_yaml(translations)
      end

      describe '#human_object_name' do
        it 'returns the correct translation' do
          expect(translated_object.human_object_name)
            .to(
              eq("#{translation_string} Name")
            )
        end
      end

      describe '#human_attribute_name' do
        it 'returns the correct translation' do
          expect(translated_object.human_attribute_name(:attribute_name))
            .to(eq("#{translation_string} Attr Name"))
        end
      end

      describe '#human_error_name' do
        it 'returns the correct translation' do
          expect(translated_object.human_error_name(:error_name))
            .to(eq("#{translation_string} Validation Error Name"))
        end
      end

      describe '#human_enum_name' do
        it 'returns the correct translation' do
          skip 'Test not implemented'

          # TODO: Replace "Enum Value" with the expected translation
          expect(translated_object.human_enum_name(:enum_name, :enum_value))
            .to(eq('Enum Value'))
        end
      end

      describe '#enum_options_for_select' do
        it 'returns the correct options' do
          skip 'Test not implemented'

          expect(translated_object.enum_options_for_select(:enum_name))
            .to(eq([['Enum Value', :enum_value]]))
        end
      end

      describe '#enum_translation_key' do
        it 'returns the correct key' do
          skip 'Test not implemented'

          expect(translated_object.enum_translation_key(:enum_name))
            .to(eq('enum_names'))
        end
      end
    end

    context 'when translation is not present' do
      before do
        translations = {
          en: {
            activerecord: {
              models: {}
            }
          }
        }

        load_test_yaml(translations)
      end

      describe '#human_object_name' do
        it 'returns the correct translation' do
          expect(translated_object.human_object_name)
            .not_to(be_blank)
        end
      end

      describe '#human_attribute_name' do
        it 'returns the correct translation' do
          expect(translated_object.human_attribute_name(:attribute_name))
            .not_to(be_blank)
        end
      end

      describe '#human_error_name' do
        it 'returns the correct translation' do
          expect(translated_object.human_error_name(:error_name))
            .not_to(be_blank)
        end
      end

      describe '#human_enum_name' do
        it 'returns the correct translation' do
          skip 'Test not implemented'

          expect(translated_object.human_enum_name(:enum_name, :enum_value))
            .to(eq('Enum Value'))
        end
      end

      describe '#enum_options_for_select' do
        it 'returns the correct options' do
          skip 'Test not implemented'

          expect(translated_object.enum_options_for_select(:enum_name))
            .to(eq([['Enum Value', :enum_value]]))
        end
      end

      describe '#enum_translation_key' do
        it 'returns the correct key' do
          expect(translated_object.enum_translation_key(:enum_name))
            .to(eq('enum_names'))
        end
      end
    end
  end
end
