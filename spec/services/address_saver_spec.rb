require 'spec_helper'
require 'app/services/address_saver'

RSpec.describe AddressSaver do
  describe '.save' do
    it 'persists form data to the selected answer store' do
      fake_answer_store = instance_double('SelectedAnswerStore')
      allow(fake_answer_store).to receive(:store_selected_answers)
      fake_form = instance_double('AddressForm',
                                  valid?: true,
                                  address_isnt_here?: false,
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

    it 'returns :success' do
      fake_answer_store = instance_double('SelectedAnswerStore')
      allow(fake_answer_store).to receive(:store_selected_answers)
      fake_form = instance_double('AddressForm',
                                  valid?: true,
                                  address_isnt_here?: false,
                                  property_reference: '00123456')
      fake_property = { property_reference: '00123456' }
      fake_api = instance_double('HackneyApi', get_property: fake_property)

      saver = AddressSaver.new(api: fake_api, selected_answer_store: fake_answer_store)
      expect(saver.save(fake_form)).to eq :success
    end

    context 'when the form is invalid' do
      it 'does not persist the form data' do
        fake_answer_store = instance_double('SelectedAnswerStore')
        allow(fake_answer_store).to receive(:store_selected_answers)
        fake_form = instance_double('AddressForm',
                                    valid?: false,
                                    address_isnt_here?: false,
                                    property_reference: '')
        fake_api = instance_double('HackneyApi')

        saver = AddressSaver.new(api: fake_api, selected_answer_store: fake_answer_store)
        saver.save(fake_form)

        expect(fake_answer_store).to_not have_received(:store_selected_answers)
      end

      it 'returns :invalid' do
        fake_answer_store = instance_double('SelectedAnswerStore')
        allow(fake_answer_store).to receive(:store_selected_answers)
        fake_form = instance_double('AddressForm',
                                    valid?: false,
                                    address_isnt_here?: false,
                                    property_reference: '')
        fake_api = instance_double('HackneyApi')

        saver = AddressSaver.new(api: fake_api, selected_answer_store: fake_answer_store)
        expect(saver.save(fake_form)).to eq :invalid
      end
    end

    context 'when the address could not be found' do
      it 'does not persist the form data' do
        fake_answer_store = instance_double('SelectedAnswerStore')
        allow(fake_answer_store).to receive(:store_selected_answers)
        fake_form = instance_double('AddressForm',
                                    valid?: true,
                                    address_isnt_here?: true,
                                    property_reference: 'address_isnt_here')
        fake_api = instance_double('HackneyApi')

        saver = AddressSaver.new(api: fake_api, selected_answer_store: fake_answer_store)
        saver.save(fake_form)

        expect(fake_answer_store).to_not have_received(:store_selected_answers)
      end

      it 'returns :not_found' do
        fake_answer_store = instance_double('SelectedAnswerStore')
        allow(fake_answer_store).to receive(:store_selected_answers)
        fake_form = instance_double('AddressForm',
                                    valid?: true,
                                    address_isnt_here?: true,
                                    property_reference: 'address_isnt_here')
        fake_api = instance_double('HackneyApi')

        saver = AddressSaver.new(api: fake_api, selected_answer_store: fake_answer_store)
        expect(saver.save(fake_form)).to eq :not_found
      end
    end

    context 'when the address is not maintainable' do
      it 'does not persist the form data' do
        fake_answer_store = instance_double('SelectedAnswerStore')
        allow(fake_answer_store).to receive(:store_selected_answers)
        fake_form = instance_double('AddressForm',
                                    valid?: true,
                                    address_isnt_here?: false,
                                    property_reference: '01234567')
        fake_api = instance_double('HackneyApi', get_property: { 'maintainable' => false })

        saver = AddressSaver.new(api: fake_api, selected_answer_store: fake_answer_store)
        saver.save(fake_form)

        expect(fake_answer_store).to_not have_received(:store_selected_answers)
      end

      it 'returns :not_maintainable' do
        fake_answer_store = instance_double('SelectedAnswerStore')
        allow(fake_answer_store).to receive(:store_selected_answers)
        fake_form = instance_double('AddressForm',
                                    valid?: true,
                                    address_isnt_here?: false,
                                    property_reference: '01234567')
        fake_api = instance_double('HackneyApi', get_property: { 'maintainable' => false })

        saver = AddressSaver.new(api: fake_api, selected_answer_store: fake_answer_store)
        expect(saver.save(fake_form)).to eq :not_maintainable
      end
    end
  end
end
