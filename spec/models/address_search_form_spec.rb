require 'spec_helper'
require 'active_model'
require 'app/validators/postcode_validator'
require 'app/models/address_search_form'

RSpec.describe AddressSearchForm do
  describe '.data' do
    it 'returns the search data as a hash' do
      params = { postcode: 'N16 8QR' }
      expect(AddressSearchForm.new(params).data).to eq(postcode: 'N16 8QR')
    end

    it 'strips surrounding whitespace on postcodes' do
      params = { postcode: " \t  N16 8QR   " }
      expect(AddressSearchForm.new(params).data).to eq(postcode: 'N16 8QR')
    end

    it 'strips extra internal spaces in postcodes' do
      params = { postcode: 'N16   8QR' }
      expect(AddressSearchForm.new(params).data).to eq(postcode: 'N16 8QR')
    end

    it 'adds a space in the middle' do
      params = { postcode: 'N168QR' }
      expect(AddressSearchForm.new(params).data).to eq(postcode: 'N16 8QR')
    end

    it 'converts postcodes to upper case' do
      params = { postcode: 'n16 8qr' }
      expect(AddressSearchForm.new(params).data).to eq(postcode: 'N16 8QR')
    end
  end

  describe 'Validations' do
    valid_postcodes = [
      'N16 8QR',
      'N1 3ND',
      'E8 1DT',
      'N1 6NU',
    ]
    valid_postcodes.each do |postcode|
      it "is valid when the postcode is #{postcode}" do
        expect(AddressSearchForm.new(postcode: postcode)).to be_valid
      end
    end

    it 'is valid for a lowercase postcode' do
      expect(AddressSearchForm.new(postcode: 'n16 8qr')).to be_valid
    end

    it 'is valid for a mixed-case postcode' do
      expect(AddressSearchForm.new(postcode: 'N16 8Qr')).to be_valid
    end

    it 'is valid with no spaces in the postcode' do
      expect(AddressSearchForm.new(postcode: 'N168QR')).to be_valid
    end

    it 'is valid with extra spaces in the middle of the postcode' do
      expect(AddressSearchForm.new(postcode: 'N16   8QR')).to be_valid
    end

    it 'is invalid when the postcode has random internal spaces' do
      # NOTE: this is what the regex gives us - not necessarily what we want
      address_search = AddressSearchForm.new(postcode: 'N 16 8QR')
      address_search.valid?
      expect(address_search.errors.full_messages).to include("Postcode doesn't seem to be valid")
    end

    it 'is invalid for a missing postcode' do
      address_search = AddressSearchForm.new({})
      address_search.valid?
      expect(address_search.errors.full_messages).to include("Postcode can't be blank")
    end

    it 'is invalid for an empty postcode' do
      address_search = AddressSearchForm.new(postcode: "   \t")
      address_search.valid?
      expect(address_search.errors.full_messages).to include("Postcode can't be blank")
    end

    it 'only shows one validation error for an empty postcode' do
      address_search = AddressSearchForm.new(postcode: "   \t")
      address_search.valid?
      expect(address_search.errors[:postcode]).to eq ["can't be blank"]
    end

    invalid_postcodes = [
      'A',
      'AAA AAA',
      'N16',
      'N16 8Q',
      'N8 QR',
    ]
    invalid_postcodes.each do |postcode|
      it "is invalid when the postcode is #{postcode}" do
        address_search = AddressSearchForm.new(postcode: postcode)
        address_search.valid?
        expect(address_search.errors.full_messages).to include("Postcode doesn't seem to be valid")
      end
    end
  end
end
