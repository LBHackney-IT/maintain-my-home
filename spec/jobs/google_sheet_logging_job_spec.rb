require 'rails_helper'

RSpec.describe GoogleSheetLoggingJob do
  describe '#call' do
    it 'posts details to the sheet' do
      repair_attributes = {
        requested_at: '2019-11-27 14:25',
        request_reference: '01234',
        sor_code: '5678',
        supplier_reference: 'W1',
        priority: 'N'
      }

      logger = double('GoogleSheetLogger')

      expect(GoogleSheetLogger).to receive(:new) { logger }
      expect(logger).to receive(:call).with(repair_attributes, 'callback')

      GoogleSheetLoggingJob.perform_now(repair_attributes, 'callback')
    end
  end
end
