require 'rails_helper'

RSpec.feature 'Users can visit all static pages' do
  scenario 'receiving a positive valid response' do
    HighVoltage.page_ids.each do |id|
      visit "/pages/#{id}"

      expect(page).to have_http_status(:ok)
    end
  end
end
