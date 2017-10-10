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

  describe 'full_name' do
    it 'returns the stored name' do
      fake_answers = {
        'contact_details' => {
          'full_name' => 'Alan Groves',
        },
      }

      expect(Confirmation.new(repair_request_id: '00000000', answers: fake_answers).full_name)
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

      expect(Confirmation.new(repair_request_id: '00000000', answers: fake_answers).telephone_number)
        .to eq '02013579753'
    end
  end

  describe 'callback_time' do
    context 'when the stored callback time was morning' do
      it 'returns a user-readable string based on the stored callback time' do
        fake_answers = {
          'contact_details' => {
            'callback_time' => ['morning'],
          },
        }

        expect(Confirmation.new(repair_request_id: '00000000', answers: fake_answers).callback_time)
          .to eq 'between 8am and 12pm'
      end
    end

    context 'when the stored callback time was afternoon' do
      it 'returns a user-readable string based on the stored callback time' do
        fake_answers = {
          'contact_details' => {
            'callback_time' => ['afternoon'],
          },
        }

        expect(Confirmation.new(repair_request_id: '00000000', answers: fake_answers).callback_time)
          .to eq 'between 12pm and 5pm'
      end
    end

    context 'when the stored callback time was both morning and afternoon' do
      it 'returns a user-readable string based on the stored callback time' do
        fake_answers = {
          'contact_details' => {
            'callback_time' => %w[morning afternoon],
          },
        }

        expect(Confirmation.new(repair_request_id: '00000000', answers: fake_answers).callback_time)
          .to eq 'between 8am and 5pm'
      end
    end

    context 'when the stored callback time was a string (not an array)' do
      it 'raises an exception' do
        fake_answers = {
          'contact_details' => {
            'callback_time' => 'morning',
          },
        }

        expect { Confirmation.new(repair_request_id: '00000000', answers: fake_answers).callback_time }
          .to raise_error(Confirmation::InvalidCallbackTimeError)
      end
    end

    context 'when the stored callback time was not recognised' do
      it 'raises an exception' do
        fake_answers = {
          'contact_details' => {
            'callback_time' => %w[teatime],
          },
        }

        expect { Confirmation.new(repair_request_id: '00000000', answers: fake_answers).callback_time }
          .to raise_error(Confirmation::InvalidCallbackTimeError)
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

      expect(Confirmation.new(repair_request_id: '00000000', answers: fake_answers).description)
        .to eq 'My bath is broken'
    end
  end
end
