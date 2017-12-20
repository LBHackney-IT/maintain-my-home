require 'spec_helper'
require 'app/services/address_saver'

RSpec.describe AddressSaver do
  describe '.save' do
    it 'persists form data to the selected answer store' do
      fake_answer_store = instance_double('SelectedAnswerStore')
      allow(fake_answer_store).to receive(:store_selected_answers)
      fake_form = instance_double('AddressForm',
                                  valid?: true,
                                  property_reference: '00123456')
      fake_property = { property_reference: '00123456' }
      fake_api = instance_double('HackneyApi', get_property: fake_property)

      saver = AddressSaver.new(api: fake_api, selected_answer_store: fake_answer_store)
      saver.save(fake_form)

      expect(fake_answer_store)
        .to have_received(:store_selected_answers)
        .with(
          'address',
          fake_property,
        )
    end

    it 'returns true' do
      fake_answer_store = instance_double('SelectedAnswerStore')
      allow(fake_answer_store).to receive(:store_selected_answers)
      fake_form = instance_double('AddressForm',
                                  valid?: true,
                                  property_reference: '00123456')
      fake_property = { property_reference: '00123456' }
      fake_api = instance_double('HackneyApi', get_property: fake_property)

      saver = AddressSaver.new(api: fake_api, selected_answer_store: fake_answer_store)
      expect(saver.save(fake_form)).to eq true
    end

    context 'when the form is invalid' do
      it 'does not persist the form data' do
        fake_answer_store = instance_double('SelectedAnswerStore')
        allow(fake_answer_store).to receive(:store_selected_answers)
        fake_form = instance_double('AddressForm',
                                    valid?: false,
                                    property_reference: '')
        fake_api = instance_double('HackneyApi')

        saver = AddressSaver.new(api: fake_api, selected_answer_store: fake_answer_store)
        saver.save(fake_form)

        expect(fake_answer_store).to_not have_received(:store_selected_answers)
      end

      it 'returns false' do
        fake_answer_store = instance_double('SelectedAnswerStore')
        allow(fake_answer_store).to receive(:store_selected_answers)
        fake_form = instance_double('AddressForm',
                                    valid?: false,
                                    property_reference: '')
        fake_api = instance_double('HackneyApi')

        saver = AddressSaver.new(api: fake_api, selected_answer_store: fake_answer_store)
        expect(saver.save(fake_form)).to eq false
      end
    end
  end
end
