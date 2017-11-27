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
          'propertyReference' => '00034713',
          'address' => 'Ross Court 25',
          'postcode' => 'E5 8TE',
        },
        'contact_details' => {
          'full_name' => 'Jo Bloggs',
          'telephone_number' => '07900 123456',
        },
        'describe_repair' => {
          'description' => 'My bath is broken',
        },
        'room' => {
          'room' => 'Bathroom',
        },
      }

      service = CreateRepair.new(api: fake_api)
      service.call(answers: fake_answers)

      expect(fake_api).to have_received(:create_repair)
        .with(
          priority: 'N',
          problemDescription: "My bath is broken\n\nRoom: Bathroom",
          propertyReference: '00034713',
          contact: {
            name: 'Jo Bloggs',
            telephoneNumber: '07900 123456',
          }
        )
    end

    it 'returns a result containing the repair request reference' do
      fake_api = instance_double('HackneyApi')
      allow(fake_api).to receive(:create_repair)
        .and_return(
          'repairRequestReference' => '03153917',
          'problemDescription' => 'My bath is broken',
          'priority' => 'N',
          'propertyReference' => '00034713',
          'contact' => {
            'name' => 'Jo Apple',
            'telephoneNumber' => '07900 880110',
          },
        )

      fake_answers = {
        'address' => {
          'propertyReference' => '00034713',
          'address' => 'Ross Court 25',
          'postcode' => 'E5 8TE',
        },
        'contact_details' => {
          'full_name' => 'Jo Apple',
          'telephone_number' => '07900 880110',
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
        problemDescription: 'No description given',
        propertyReference: '00034713',
        contact: {
          name: 'Jo Bloggs',
          telephoneNumber: '07900 123456',
        }
      )

    fake_answers = {
      'address' => {
        'propertyReference' => '00034713',
        'address' => 'Ross Court 25',
        'postcode' => 'E5 8TE',
      },
      'contact_details' => {
        'full_name' => 'Jo Bloggs',
        'telephone_number' => '07900 123456',
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
          'propertyReference' => '00034713',
          'address' => 'Ross Court 25',
          'postcode' => 'E5 8TE',
        },
        'contact_details' => {
          'full_name' => 'Alex Doe',
          'telephone_number' => '020 8534 1234',
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
          problemDescription: 'My bath is broken',
          propertyReference: '00034713',
          contact: {
            name: 'Alex Doe',
            telephoneNumber: '020 8534 1234',
          },
          workOrders: [
            { sorCode: '002034' },
          ],
        )
    end

    it 'returns a result which exposes the repair request reference' do
      fake_api = instance_double('HackneyApi')
      allow(fake_api).to receive(:create_repair)
        .and_return(
          'repairRequestReference' => '03153917',
          'problemDescription' => 'My bath is broken',
          'priority' => 'N',
          'propertyReference' => '00034713',
          'contact' => {
            'name' => 'Jo Apple',
            'telephoneNumber' => '07900 880110',
          },
          'workOrders' => [
            {
              'sorCode' => '20012345',
              'workOrderReference' => '09876543',
            },
          ],
        )
      fake_answers = {
        'address' => {
          'propertyReference' => '00034713',
          'address' => 'Ross Court 25',
          'postcode' => 'E5 8TE',
        },
        'contact_details' => {
          'full_name' => 'Jo Apple',
          'telephone_number' => '07900 880110',
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
