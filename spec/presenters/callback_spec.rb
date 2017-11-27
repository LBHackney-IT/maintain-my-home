require 'spec_helper'
require 'app/presenters/callback'

RSpec.describe Callback do
  it 'is renderable' do
    expect(Callback.new(time_slot: ['afternoon'], request_reference: '00000000').to_partial_path).to eq '/confirmations/callback'
  end

  describe 'callback_time' do
    context 'when the stored callback time was morning' do
      it 'returns a user-readable string based on the stored callback time' do
        expect(Callback.new(time_slot: ['morning'], request_reference: '00000000').time)
          .to eq '8am and midday'
      end
    end

    context 'when the stored callback time was afternoon' do
      it 'returns a user-readable string based on the stored callback time' do
        expect(Callback.new(time_slot: ['afternoon'], request_reference: '00000000').time)
          .to eq 'midday and 5pm'
      end
    end

    context 'when the stored callback time was both morning and afternoon' do
      it 'returns a user-readable string based on the stored callback time' do
        expect(Callback.new(time_slot: %w[morning afternoon], request_reference: '00000000').time)
          .to eq '8am and 5pm'
      end
    end

    context 'when the stored callback time was a string (not an array)' do
      it 'raises an exception' do
        expect { Callback.new(time_slot: 'morning', request_reference: '00000000').time }
          .to raise_error(Callback::TimeSlot::InvalidCallbackTimeError)
      end
    end

    context 'when the stored callback time was not recognised' do
      it 'raises an exception' do
        expect { Callback.new(time_slot: ['teatime'], request_reference: '00000000').time }
          .to raise_error(Callback::TimeSlot::InvalidCallbackTimeError)
      end
    end
  end

  describe 'request_reference' do
    it 'returns the value it was initialized with' do
      expect(Callback.new(time_slot: ['afternoon'], request_reference: '00123456').request_reference)
        .to eq '00123456'
    end
  end
end
