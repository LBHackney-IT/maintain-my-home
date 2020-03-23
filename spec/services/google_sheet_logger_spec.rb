require 'rails_helper'

RSpec.describe GoogleSheetLogger do
  describe '#call' do
    it 'posts details to the sheet' do
      repair_attributes = {
        requested_at: '2019-11-27 14:25',
        request_reference: '01234',
        sor_code: '5678',
        supplier_reference: 'W1',
        priority: 'N'
      }

      fake_session = double
      fake_spreadsheet = double
      fake_worksheets = double
      fake_worksheet = double
      allow(fake_session).to receive(:spreadsheet_by_key)
        .and_return(fake_spreadsheet)
      allow(fake_spreadsheet).to receive(:worksheets)
        .and_return(fake_worksheets)
      allow(fake_worksheets).to receive(:[])
        .and_return(fake_worksheet)
      allow(fake_worksheet).to receive(:num_rows)
        .and_return(1)
      allow(fake_worksheet).to receive(:[]=)
      allow(fake_worksheet).to receive(:save)

      allow(GoogleDrive::Session).to receive(:from_service_account_key)
        .and_return(fake_session)

      GoogleSheetLogger.new.call(repair_attributes, 'callback')

      expect(fake_worksheet).to have_received(:[]=).with(2, 1, '2019-11-27 14:25')
      expect(fake_worksheet).to have_received(:[]=).with(2, 2, '01234')
      expect(fake_worksheet).to have_received(:[]=).with(2, 3, '5678')
      expect(fake_worksheet).to have_received(:[]=).with(2, 4, 'W1')
      expect(fake_worksheet).to have_received(:[]=).with(2, 5, 'N')
      expect(fake_worksheet).to have_received(:[]=).with(2, 6, 'callback')
    end
  end
end
