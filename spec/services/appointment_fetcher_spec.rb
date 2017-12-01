require 'rails_helper'

RSpec.describe AppointmentFetcher do
  it 'returns available appointments' do
    available_appointments = [
      { 'beginDate' => '2017-10-11T10:00:00Z', 'endDate' => '2017-10-11T12:00:00Z', 'bestSlot' => false },
      { 'beginDate' => '2017-10-11T12:00:00Z', 'endDate' => '2017-10-11T17:00:00Z', 'bestSlot' => false },
    ]

    fake_api = instance_double(HackneyApi)
    allow(fake_api).to receive(:list_available_appointments)
      .and_return(available_appointments)
    allow(HackneyApi).to receive(:new).and_return(fake_api)

    appointments = AppointmentFetcher.new.call(work_order_reference: '04819510')

    expect(appointments).to eql available_appointments
  end
end
