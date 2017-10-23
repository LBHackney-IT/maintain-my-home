require 'spec_helper'
require 'app/models/repair'
require 'app/presenters/callback'
require 'app/presenters/appointment'
require 'app/presenters/confirmation'

RSpec.describe Confirmation do
  describe '#request_reference' do
    context 'when there is a work order' do
      it 'is the work order reference' do
        fake_api = instance_double('HackneyApi')
        allow(fake_api).to receive(:get_repair)
          .with(repair_request_reference: '00004578')
          .and_return(
            'requestReference' => '00004578',
            'orderReference' => '00412371',
            'problem' => 'My bath is broken',
            'priority' => 'N',
            'propertyRef' => '00034713',
          )
        expect(Confirmation.new(request_reference: '00004578', answers: {}, api: fake_api).request_reference)
          .to eq '00412371'
      end
    end

    context 'when there are no work orders' do
      it 'is the repair request reference' do
        fake_api = instance_double('HackneyApi')
        allow(fake_api).to receive(:get_repair)
          .with(repair_request_reference: '00004578')
          .and_return(
            'requestReference' => '00004578',
            'problem' => 'My bath is broken',
            'priority' => 'N',
            'propertyRef' => '00034713',
          )
        expect(Confirmation.new(request_reference: '00004578', answers: {}, api: fake_api).request_reference)
          .to eq '00004578'
      end
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

      expect(Confirmation.new(request_reference: '00000000', answers: fake_answers, api: double).address)
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

      expect(Confirmation.new(request_reference: '00000000', answers: fake_answers, api: double).full_name)
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

      expect(Confirmation.new(request_reference: '00000000', answers: fake_answers, api: double).telephone_number)
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
        action = Confirmation.new(request_reference: '00000000', answers: fake_answers, api: double).scheduled_action
        expect(action.to_partial_path).to eq '/confirmations/callback'
      end
    end

    context 'when there was an appointment' do
      it 'returns a renderable object' do
        fake_answers = {
          'appointment' => double, # TODO: replace with a more realistic value
        }
        action = Confirmation.new(request_reference: '00000000', answers: fake_answers, api: double).scheduled_action
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

      expect(Confirmation.new(request_reference: '00000000', answers: fake_answers, api: double).description)
        .to eq 'My bath is broken'
    end
  end
end
