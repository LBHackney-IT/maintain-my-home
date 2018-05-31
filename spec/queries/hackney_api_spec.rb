require 'spec_helper'
require 'app/queries/hackney_api'

describe HackneyApi do
  describe '#list_properties' do
    it 'returns a list of properties' do
      results = [
        { 'propertyReference' => 'def567', 'address' => 'Flat 8, 1 Aardvark Road', 'postcode' => 'A1 1AA' },
      ]
      json_api = double(get: { 'results' => results })
      api = HackneyApi.new(json_api)

      expect(api.list_properties(postcode: 'A1 1AA')).to eql results
    end

    it 'raises MissingResults if the "results" key is missing from the response' do
      response = {
        'no_result_key_here' => 'epic_fail',
      }

      json_api = double(get: response)
      api = HackneyApi.new(json_api)

      expect { api.list_properties(postcode: 'A1 1AA') }.to raise_error(KeyError)
    end
  end

  describe '#get_property' do
    it 'returns an individual property' do
      results = {
        'propertyReference' => 'cre045',
        'address' => 'Flat 45, Cheddar Row Estate',
        'postcode' => 'N1 1AA',
      }
      json_api = instance_double('JsonApi')
      allow(json_api).to receive(:get).with('hackneyrepairs/v1/properties/cre045').and_return(results)
      api = HackneyApi.new(json_api)

      expect(api.get_property(property_reference: 'cre045')).to eql results
    end
  end

  describe '#create_repair' do
    it 'sends repair creation parameters' do
      json_api = instance_double('JsonApi')
      allow(json_api).to receive(:post).with('hackneyrepairs/v1/repairs', anything)

      api = HackneyApi.new(json_api)
      repair_params = {
        priority: 'U',
        problemDescription: 'It is broken',
        propertyReference: '01234567',
      }
      api.create_repair(repair_params)

      expect(json_api).to have_received(:post)
        .with(
          'hackneyrepairs/v1/repairs',
          priority: 'U',
          problemDescription: 'It is broken',
          propertyReference: '01234567',
        )
    end

    it 'returns the result from the api call' do
      json_api = instance_double('JsonApi')
      result = double('api result')
      allow(json_api).to receive(:post)
        .with('hackneyrepairs/v1/repairs', anything)
        .and_return result

      api = HackneyApi.new(json_api)
      expect(api.create_repair(double)).to eq result
    end
  end

  describe '#get_repair' do
    it 'returns an individual repair' do
      result = {
        'repairRequestReference' => '00045678',
        'problemDescription' => 'My bath is broken',
        'priority' => 'N',
        'propertyReference' => '00034713',
        'workOrders' => [
          {
            'sorCode' => '20164242',
            'workOrderReference' => '00412371',
          },
        ],
      }
      json_api = instance_double('JsonApi')
      allow(json_api).to receive(:get).with('hackneyrepairs/v1/repairs/00045678').and_return(result)
      api = HackneyApi.new(json_api)

      expect(api.get_repair(repair_request_reference: '00045678')).to eql result
    end
  end

  describe '#list_available_appointments' do
    it 'returns a list of available appointments for a work order' do
      appointments = [
        {
          'beginDate' => '2017-11-01T08:00:00Z',
          'endDate' => '2017-11-01T12:00:00Z',
          'bestSlot' => true,
        },
        {
          'beginDate' => '2017-11-01T12:00:00Z',
          'endDate' => '2017-11-01T16:15:00Z',
          'bestSlot' => false,
        },
      ]

      json_api = instance_double('JsonApi')
      result = { 'results' => appointments }
      allow(json_api).to receive(:get).with('hackneyrepairs/v1/work_orders/00412371/available_appointments').and_return(result)
      api = HackneyApi.new(json_api)

      expect(api.list_available_appointments(work_order_reference: '00412371')).to eql appointments
    end
  end

  describe '#book_appointment' do
    it 'books an appointment for a work order' do
      result = {
        'beginDate' => '2017-11-01T14:00:00Z',
        'endDate' => '2017-11-01T16:30:00Z',
      }

      json_api = instance_double('JsonApi')
      allow(json_api)
        .to receive(:post)
        .with(
          'hackneyrepairs/v1/work_orders/00412371/appointments',
          beginDate: '2017-11-01T14:00:00Z',
          endDate: '2017-11-01T16:30:00Z'
        )
        .and_return(result)

      api = HackneyApi.new(json_api)
      expect(
        api.book_appointment(
          work_order_reference: '00412371',
          begin_date: '2017-11-01T14:00:00Z',
          end_date: '2017-11-01T16:30:00Z'
        )
      ).to eql result
    end
  end
end
