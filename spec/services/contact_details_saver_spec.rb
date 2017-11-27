require 'spec_helper'
require 'app/services/contact_details_saver'

RSpec.describe ContactDetailsSaver do
  describe '.save' do
    it 'persists form data to the selected answer store' do
      fake_answer_store = instance_double('SelectedAnswerStore')
      allow(fake_answer_store).to receive(:store_selected_answers)
      fake_form = instance_double('ContactDetailsWithCallbackForm',
                                  valid?: true,
                                  full_name: 'Alan Stubbs',
                                  telephone_number: '0456765432',
                                  callback_time: ['morning'])

      saver = ContactDetailsSaver.new(selected_answer_store: fake_answer_store)
      saver.save(fake_form)

      expect(fake_answer_store)
        .to have_received(:store_selected_answers)
        .with(
          'contact_details',
          'full_name' => 'Alan Stubbs',
          'telephone_number' => '0456765432',
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

      saver = ContactDetailsSaver.new(selected_answer_store: fake_answer_store)
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

        saver = ContactDetailsSaver.new(selected_answer_store: fake_answer_store)
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

        saver = ContactDetailsSaver.new(selected_answer_store: fake_answer_store)
        expect(saver.save(fake_form)).to eq false
      end
    end
  end
end
