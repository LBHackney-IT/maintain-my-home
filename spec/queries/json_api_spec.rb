require 'spec_helper'
require 'app/queries/json_api'

RSpec.describe JsonApi do
  describe '#get' do
    it 'does not raise an error' do
      json_api = JsonApi.new

      expect { json_api.get('asfasf') }.not_to raise_error
    end

    it 'returns a fixed response' do
      json_api = JsonApi.new

      results = [
        { 'property_reference' => 'zxc987', 'short_address' => '221B Aardvark Road, A1 1AA' },
      ]

      expect(json_api.get('not/a/real/path')).to eq(results)
    end
  end
end
