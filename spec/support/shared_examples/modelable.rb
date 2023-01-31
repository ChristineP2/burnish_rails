# frozen_string_literal: true

# it_behaves_like "an active record model"
RSpec.shared_examples_for('an active record model') do
  it 'includes ActiveModel API' do
    expect(described_class.included_modules)
      .to(include(ActiveModel::API))
  end

  it 'includes ActiveModel Attributes' do
    expect(described_class.included_modules)
      .to(include(ActiveModel::Attributes))
  end
end
