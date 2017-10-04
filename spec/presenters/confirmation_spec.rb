require 'spec_helper'
require 'app/presenters/confirmation'

RSpec.describe Confirmation do
  describe '#repair_request_id' do
    it 'is the value passed when the confirmation is built' do
      expect(Confirmation.new(repair_request_id: '00004578', answers: {}).repair_request_id)
        .to eq '00004578'
    end
  end

  describe 'address' do
    it 'builds an address from the selected answers' do
      fake_answers = {
        'address' => {
          'property_reference' => '01234567',
          'short_address' => 'Ross Court 25',
          'postcode' => 'E5 8TE',
        },
      }

      expect(Confirmation.new(repair_request_id: '00000000', answers: fake_answers).address)
        .to eq 'Ross Court 25, E5 8TE'
    end
  end
end
