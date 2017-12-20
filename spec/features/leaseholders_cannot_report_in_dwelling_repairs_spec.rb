require 'rails_helper'

RSpec.feature 'Leaseholders cannot report in-dwelling repairs' do
  scenario 'after choosing their address, they see a message asking them to call the RCC' do
    property = {
      'propertyReference' => '00001234',
      'address' => '5 Paloma Street',
      'postcode' => 'N1 6NN',
      'maintainable' => false,
    }

    fake_api = instance_double(JsonApi)
    allow(fake_api).to receive(:get)
      .with('v1/properties?postcode=N1 6NN')
      .and_return('results' => [property])
    allow(fake_api).to receive(:get)
      .with('v1/properties/00001234')
      .and_return(property)
    allow(JsonApi).to receive(:new).and_return(fake_api)

    visit '/address-search'

    fill_in 'Postcode', with: 'N1 6NN'
    click_on 'Find my address'

    choose_radio_button '5 Paloma Street'
    click_on 'Continue'

    expect(page).to have_content "We can't report a repair for your address"
  end
end
