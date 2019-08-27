require 'spec_helper'
require 'app/services/find_cautionary_contact'

RSpec.describe FindCautionaryContact do
  describe '#present?' do
    it 'returns true if there is no cautionary contact information' do
      fake_cautionary_contact = { 'results' => { 'alertCodes' => [nil], 'callerNotes'=> [nil] } }
      fake_api = instance_double('HackneyApi', get_cautionary_contacts: fake_cautionary_contact)

      expect(fake_api).to receive(:get_cautionary_contacts).with(property_reference: '123' )

      result = described_class.new(api: fake_api, property_reference: '123').present?

      expect(result).to eq(false)
    end

    context 'when there is no cautionary contact information but it is expressed as empty arrays' do
      it 'returns true' do
        fake_cautionary_contact = { 'results' => { 'alertCodes' => [], 'callerNotes'=> [] } }
        fake_api = instance_double('HackneyApi', get_cautionary_contacts: fake_cautionary_contact)

        result = described_class.new(api: fake_api, property_reference: '123').present?

        expect(result).to eq(false)
      end
    end

    context 'when there is cautionary contact information through an alert code' do
      it 'returns true' do
        fake_cautionary_contact = { 'results' => { 'alertCodes' => ['CV'], 'callerNotes'=> [] } }
        fake_api = instance_double('HackneyApi', get_cautionary_contacts: fake_cautionary_contact)

        result = described_class.new(api: fake_api, property_reference: '123').present?

        expect(result).to eq(true)
      end
    end

    context 'when there is cautionary contact information through a caller note' do
      it 'returns true' do
        fake_cautionary_contact = { 'results' => { 'alertCodes' => [nil], 'callerNotes'=> ['Arrange any visits with M.Donald on 07123456789'] } }
        fake_api = instance_double('HackneyApi', get_cautionary_contacts: fake_cautionary_contact)

        result = described_class.new(api: fake_api, property_reference: '123').present?

        expect(result).to eq(true)
      end
    end

    context 'when there alert codes and caller notes' do
      it 'returns true' do
        fake_cautionary_contact = { 'results' => { 'alertCodes' => ['CV'], 'callerNotes'=> ['Arrange any visits with M.Donald on 07123456789'] } }
        fake_api = instance_double('HackneyApi', get_cautionary_contacts: fake_cautionary_contact)

        result = described_class.new(api: fake_api, property_reference: '123').present?

        expect(result).to eq(true)
      end
    end

    context 'when unexpected values are returned' do
      it 'returns true' do
        fake_cautionary_contact = { 'results' => { 'I am an unknown key' => ['CV'], 'callerNotes'=> 'I am a string, not an array' } }
        fake_api = instance_double('HackneyApi', get_cautionary_contacts: fake_cautionary_contact)

        result = described_class.new(api: fake_api, property_reference: '123').present?

        expect(result).to eq(true)
      end
    end
  end

  describe '#not_present?' do
    it 'returns the inverted result of present?' do
      fake_cautionary_contact = { 'results' => { 'alertCodes' => ['CV'], 'callerNotes'=> ['Arrange any visits with M.Donald on 07123456789'] } }
      fake_api = instance_double('HackneyApi', get_cautionary_contacts: fake_cautionary_contact)

      present_result = described_class.new(api: fake_api, property_reference: '123').present?
      not_present_result = described_class.new(api: fake_api, property_reference: '123').not_present?

      expect(present_result).to eq(true)
      expect(not_present_result).to eq(false)
    end
  end
end
