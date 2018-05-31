require 'rails_helper'

RSpec.describe GoogleSheetLogger do
  describe '#call' do
    it 'posts details to the sheet' do
      fake_repair = instance_double(Repair)
      allow(fake_repair).to receive(:request_reference).and_return('01234')
      allow(fake_repair).to receive(:sor_code).and_return('5678')
      allow(fake_repair).to receive(:supplier_reference).and_return('W1')
      allow(fake_repair).to receive(:priority).and_return('N')

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

      GoogleSheetLogger.new.call(fake_repair, 'callback')

      expect(fake_worksheet).to have_received(:[]=).with(2, 2, '01234')
      expect(fake_worksheet).to have_received(:[]=).with(2, 3, '5678')
      expect(fake_worksheet).to have_received(:[]=).with(2, 4, 'W1')
      expect(fake_worksheet).to have_received(:[]=).with(2, 5, 'N')
      expect(fake_worksheet).to have_received(:[]=).with(2, 6, 'callback')
    end
  end
end
