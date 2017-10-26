require 'spec_helper'
require 'app/models/description_partial_checker'

RSpec.describe DescriptionPartialChecker do
  describe '#exists?' do
    context 'when the partial exists' do
      it 'is true' do
        fake_lookup_context = instance_double('ActionView::LookupContext')
        allow(fake_lookup_context).to receive(:exists?)
          .with('a_real_template', 'describe_repair', true)
          .and_return(true)
        checker = DescriptionPartialChecker.new(lookup_context: fake_lookup_context)
        expect(checker.exists?('a_real_template')).to eq true
      end
    end

    context 'when the partial does not exist' do
      it 'is true' do
        fake_lookup_context = instance_double('ActionView::LookupContext')
        allow(fake_lookup_context).to receive(:exists?)
          .with('an_imaginary_template', 'describe_repair', true)
          .and_return(false)
        checker = DescriptionPartialChecker.new(lookup_context: fake_lookup_context)
        expect(checker.exists?('an_imaginary_template')).to eq false
      end
    end

    context 'when the partial is nil' do
      it 'is false' do
        fake_lookup_context = instance_double('ActionView::LookupContext')
        checker = DescriptionPartialChecker.new(lookup_context: fake_lookup_context)
        expect(checker.exists?(nil)).to eq false
      end
    end
  end
end
