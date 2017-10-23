require 'spec_helper'
require 'app/presenters/callback'
require 'app/presenters/confirmation'

RSpec.describe Confirmation do
  describe '#request_reference' do
    it 'is the value passed when the confirmation is built' do
      expect(Confirmation.new(request_reference: '00004578', answers: {}).request_reference)
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

      expect(Confirmation.new(request_reference: '00000000', answers: fake_answers).address)
        .to eq 'Ross Court 25, E5 8TE'
    end
  end

  describe 'full_name' do
    it 'returns the stored name' do
      fake_answers = {
        'contact_details' => {
          'full_name' => 'Alan Groves',
        },
      }

      expect(Confirmation.new(request_reference: '00000000', answers: fake_answers).full_name)
        .to eq 'Alan Groves'
    end
  end

  describe 'telephone_number' do
    it 'strips out any spaces from stored phone numbers' do
      # TODO: this is an intial simple implementaion for simplicity.
      # At some point we should format numbers nicely, which will make it easier
      # to see if a mistake has been made
      fake_answers = {
        'contact_details' => {
          'telephone_number' => ' 0201 357 9753',
        },
      }

      expect(Confirmation.new(request_reference: '00000000', answers: fake_answers).telephone_number)
        .to eq '02013579753'
    end
  end

  describe 'scheduled_action' do
    context 'when there was a callback time' do
      it 'returns a renderable object' do
        fake_answers = {
          'callback_time' => {
            'callback_time' => ['morning'],
          },
        }
        action = Confirmation.new(request_reference: '00000000', answers: fake_answers).scheduled_action
        expect(action.to_partial_path).to eq '/confirmations/callback'
      end
    end

    context 'when there was an appointment' do
      it 'returns a renderable object' do
        fake_answers = {
          'appointment' => double, # TODO: replace with a more realistic value
        }
        action = Confirmation.new(request_reference: '00000000', answers: fake_answers).scheduled_action
        expect(action.to_partial_path).to eq '/confirmations/appointment'
      end
    end
  end

  describe 'description' do
    it 'Returns the stored description' do
      fake_answers = {
        'describe_repair' => {
          'description' => 'My bath is broken',
        },
      }

      expect(Confirmation.new(request_reference: '00000000', answers: fake_answers).description)
        .to eq 'My bath is broken'
    end
  end
end
