class GoogleSheetLogger
  def initialize
    if ENV['GOOGLE_APPLICATION_CREDENTIALS']
      @credentials = StringIO.new(ENV['GOOGLE_APPLICATION_CREDENTIALS'])
    else
      @credentials = 'config/google_cred.json'
    end
    @session = GoogleDrive::Session.from_service_account_key(@credentials)
    @spreadsheet = @session.spreadsheet_by_key(ENV['GOOGLE_SHEET_KEY'])
    @worksheet = @spreadsheet.worksheets[0]
  end

  def call(repair_attributes, callback)
    row = @worksheet.num_rows + 1
    @worksheet[row, 1] = repair_attributes[:requested_at]
    @worksheet[row, 2] = repair_attributes[:request_reference]
    @worksheet[row, 3] = repair_attributes[:sor_code]
    @worksheet[row, 4] = repair_attributes[:supplier_reference]
    @worksheet[row, 5] = repair_attributes[:priority]
    @worksheet[row, 6] = callback
    @worksheet.save
  end
end
