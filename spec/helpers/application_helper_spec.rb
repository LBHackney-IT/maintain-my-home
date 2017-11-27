require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '#telephone_number' do
    it 'wraps the phone number in appropriate markup' do
      expect(helper.telephone_number('01234 567 890'))
        .to eq(%(<span itemprop="telephone"><a href="tel:01234567890">01234 567 890</a></span>))
    end
  end
end
