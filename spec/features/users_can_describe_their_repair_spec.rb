require 'rails_helper'

RSpec.feature 'Users can describe their repair' do
  feature 'users are shown the number of characters they can enter', js: true do
    scenario 'when the page first loads' do
      visit '/describe-repair'

      expect(page).to have_content '500 characters remaining'
    end

    scenario 'whilst entering text' do
      visit '/describe-repair'

      element = find('textarea#describe_repair_form_description')

      element.send_keys 'h'
      expect(page).to have_content '499 characters remaining'

      element.send_keys 'i'
      expect(page).to have_content '498 characters remaining'
    end

    scenario 'when reaching the limit of the textarea' do
      visit '/describe-repair'

      fill_in 'Problem description', with: 'X' * 500
      expect(page).to have_content '0 characters remaining'

      element = find('textarea#describe_repair_form_description')
      element.send_keys '*'

      expect(page).to have_content '0 characters remaining'
    end
  end
end
