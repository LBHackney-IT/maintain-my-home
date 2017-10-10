require 'spec_helper'
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
  end
end
