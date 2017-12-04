require 'spec_helper'
require 'app/models/static_page_checker'

RSpec.describe StaticPageChecker do
  describe '#exists?' do
    context 'when the page exists' do
      it 'is true' do
        fake_lookup_context = instance_double('ActionView::LookupContext')
        allow(fake_lookup_context).to receive(:exists?)
          .with('a_real_page', 'pages')
          .and_return(true)
        checker = StaticPageChecker.new(lookup_context: fake_lookup_context)
        expect(checker.exists?('a_real_page')).to eq true
      end
    end

    context 'when the page does not exist' do
      it 'is true' do
        fake_lookup_context = instance_double('ActionView::LookupContext')
        allow(fake_lookup_context).to receive(:exists?)
          .with('an_imaginary_page', 'pages')
          .and_return(false)
        checker = StaticPageChecker.new(lookup_context: fake_lookup_context)
        expect(checker.exists?('an_imaginary_page')).to eq false
      end
    end

    context 'when the page is nil' do
      it 'is false' do
        fake_lookup_context = instance_double('ActionView::LookupContext')
        checker = StaticPageChecker.new(lookup_context: fake_lookup_context)
        expect(checker.exists?(nil)).to eq false
      end
    end
  end
end
