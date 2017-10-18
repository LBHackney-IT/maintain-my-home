require 'spec_helper'
require 'app/services/callback_time_saver'

RSpec.describe CallbackTimeSaver do
  describe '.save' do
    it 'persists form data to the selected answer store' do
      fake_answer_store = instance_double('SelectedAnswerStore')
      allow(fake_answer_store).to receive(:store_selected_answers)
      fake_form = instance_double('ContactDetailsWithCallbackForm',
                                  valid?: true,
                                  full_name: 'Alan Stubbs',
                                  telephone_number: '0456765432',
                                  callback_time: ['morning'])

      saver = CallbackTimeSaver.new(selected_answer_store: fake_answer_store)
      saver.save(fake_form)

      expect(fake_answer_store)
        .to have_received(:store_selected_answers)
        .with(
          :callback_time,
          callback_time: ['morning'],
        )
    end

    it 'returns true' do
      fake_answer_store = instance_double('SelectedAnswerStore')
      allow(fake_answer_store).to receive(:store_selected_answers)
      fake_form = instance_double('ContactDetailsWithCallbackForm',
                                  valid?: true,
                                  full_name: 'Alan Stubbs',
                                  telephone_number: '0456765432',
                                  callback_time: ['morning'])

      saver = CallbackTimeSaver.new(selected_answer_store: fake_answer_store)
      expect(saver.save(fake_form)).to eq true
    end

    context 'when the form is invalid' do
      it 'does not persist the form data' do
        fake_answer_store = instance_double('SelectedAnswerStore')
        allow(fake_answer_store).to receive(:store_selected_answers)
        fake_form = instance_double('ContactDetailsWithCallbackForm',
                                    valid?: false,
                                    full_name: '',
                                    telephone_number: '',
                                    callback_time: [])

        saver = CallbackTimeSaver.new(selected_answer_store: fake_answer_store)
        saver.save(fake_form)

        expect(fake_answer_store).to_not have_received(:store_selected_answers)
      end

      it 'returns false' do
        fake_answer_store = instance_double('SelectedAnswerStore')
        allow(fake_answer_store).to receive(:store_selected_answers)
        fake_form = instance_double('ContactDetailsWithCallbackForm',
                                    valid?: false,
                                    full_name: '',
                                    telephone_number: '',
                                    callback_time: [])

        saver = CallbackTimeSaver.new(selected_answer_store: fake_answer_store)
        expect(saver.save(fake_form)).to eq false
      end
    end
  end
end
