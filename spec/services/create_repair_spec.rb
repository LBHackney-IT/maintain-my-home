require 'spec_helper'
require 'active_support/core_ext/object/blank'
require 'app/models/repair_params'
require 'app/models/repair'
require 'app/services/create_repair'

RSpec.describe CreateRepair do
  describe '#call' do
    it 'posts to the Hackney API with repair creation params' do
      fake_api = instance_double('HackneyApi')
      allow(fake_api).to receive(:create_repair)
      fake_answers = {
        'address' => {
          'property_reference' => '00034713',
          'short_address' => 'Ross Court 25',
          'postcode' => 'E5 8TE',
        },
        'describe_repair' => {
          'description' => 'My bath is broken',
        },
      }

      service = CreateRepair.new(api: fake_api)
      service.call(answers: fake_answers)

      expect(fake_api).to have_received(:create_repair)
        .with(
          priority: 'N',
          problem: 'My bath is broken',
          propertyRef: '00034713',
        )
    end

    it 'returns a result containing the request reference' do
      fake_api = instance_double('HackneyApi')
      allow(fake_api).to receive(:create_repair)
        .and_return(
          'requestReference' => '03153917',
          'problem' => 'My bath is broken',
          'priority' => 'N',
          'propertyRef' => '00034713',
        )

      fake_answers = {
        'address' => {
          'property_reference' => '00034713',
          'short_address' => 'Ross Court 25',
          'postcode' => 'E5 8TE',
        },
        'describe_repair' => {
          'description' => 'My bath is broken',
        },
      }

      service = CreateRepair.new(api: fake_api)
      expect(service.call(answers: fake_answers).request_reference)
        .to eq '03153917'
    end
  end

  it 'posts a default description, if none was provided' do
    fake_api = instance_double('HackneyApi')
    expect(fake_api).to receive(:create_repair)
      .with(
        priority: 'N',
        problem: 'n/a',
        propertyRef: '00034713'
      )

    fake_answers = {
      'address' => {
        'property_reference' => '00034713',
        'short_address' => 'Ross Court 25',
        'postcode' => 'E5 8TE',
      },
      'describe_repair' => {
        'description' => '',
      },
    }

    service = CreateRepair.new(api: fake_api)
    service.call(answers: fake_answers)
  end

  context 'when an SOR code was identified' do
    it 'posts to the Hackney API with repair creation params including work orders' do
      fake_api = instance_double('HackneyApi')
      allow(fake_api).to receive(:create_repair)
      fake_answers = {
        'address' => {
          'property_reference' => '00034713',
          'short_address' => 'Ross Court 25',
          'postcode' => 'E5 8TE',
        },
        'describe_repair' => {
          'description' => 'My bath is broken',
        },
        'diagnosis' => {
          'sor_code' => '002034',
        },
      }

      service = CreateRepair.new(api: fake_api)
      service.call(answers: fake_answers)

      expect(fake_api).to have_received(:create_repair)
        .with(
          priority: 'N',
          problem: 'My bath is broken',
          propertyRef: '00034713',
          repairOrders: [
            { jobCode: '002034', propertyReference: '00034713' },
          ],
        )
    end

    it 'returns a result which exposes the request reference' do
      fake_api = instance_double('HackneyApi')
      allow(fake_api).to receive(:create_repair)
        .and_return(
          'requestReference' => '03153917',
          'orderReference' => '09876543',
          'problem' => 'My bath is broken',
          'priority' => 'N',
          'propertyRef' => '00034713',
        )
      fake_answers = {
        'address' => {
          'property_reference' => '00034713',
          'short_address' => 'Ross Court 25',
          'postcode' => 'E5 8TE',
        },
        'describe_repair' => {
          'description' => 'My bath is broken',
        },
        'diagnosis' => {
          'sor_code' => '002034',
        },
      }

      service = CreateRepair.new(api: fake_api)
      expect(service.call(answers: fake_answers).request_reference).to eq '03153917'
    end
  end
end
