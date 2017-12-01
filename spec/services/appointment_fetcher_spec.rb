require 'rails_helper'

RSpec.describe AppointmentFetcher do
  it 'returns available appointments' do
    available_appointments = [
      { 'beginDate' => '2017-10-11T10:00:00Z', 'endDate' => '2017-10-11T12:00:00Z', 'bestSlot' => true },
      { 'beginDate' => '2017-10-11T12:00:00Z', 'endDate' => '2017-10-11T17:00:00Z', 'bestSlot' => true },
    ]

    stub_appointments(available_appointments)

    travel_to Time.zone.local(2017, 10, 1) do
      appointments = AppointmentFetcher.new.call(work_order_reference: '04819510')

      expect(appointments).to eql available_appointments
    end
  end

  it 'excludes appointment slots before tomorrow' do
    past_appointment = { 'beginDate' => '2017-10-09T16:00:00Z', 'endDate' => '2017-10-09T18:00:00Z', 'bestSlot' => true }
    today_appointment = { 'beginDate' => '2017-10-11T10:00:00Z', 'endDate' => '2017-10-11T12:00:00Z', 'bestSlot' => true }
    tomorrow_appointment = { 'beginDate' => '2017-10-12T12:00:00Z', 'endDate' => '2017-10-12T17:00:00Z', 'bestSlot' => true }

    stub_appointments([past_appointment, today_appointment, tomorrow_appointment])

    travel_to Time.zone.local(2017, 10, 11) do
      appointments = AppointmentFetcher.new.call(work_order_reference: '1234')

      expect(appointments).to include tomorrow_appointment
      expect(appointments).not_to include past_appointment
      expect(appointments).not_to include today_appointment
    end
  end

  it 'excludes all day appointments' do
    regular_appointment = { 'beginDate' => '2017-10-12T10:00:00Z', 'endDate' => '2017-10-12T14:00:00Z', 'bestSlot' => true }
    long_appointment = { 'beginDate' => '2017-10-12T09:00:00Z', 'endDate' => '2017-10-12T18:00:00Z', 'bestSlot' => true }

    stub_appointments([regular_appointment, long_appointment])

    travel_to Time.zone.local(2017, 10, 1) do
      appointments = AppointmentFetcher.new.call(work_order_reference: '1234')

      expect(appointments).to include regular_appointment
      expect(appointments).not_to include long_appointment
    end
  end

  it 'excludes appointments that are not "best" slots' do
    best_slot = { 'beginDate' => '2017-10-11T10:00:00Z', 'endDate' => '2017-10-11T12:00:00Z', 'bestSlot' => true }
    non_best_slot = { 'beginDate' => '2017-10-11T12:00:00Z', 'endDate' => '2017-10-11T14:00:00Z', 'bestSlot' => false }

    stub_appointments([best_slot, non_best_slot])

    travel_to Time.zone.local(2017, 10, 1) do
      appointments = AppointmentFetcher.new.call(work_order_reference: '1234')

      expect(appointments).to include best_slot
      expect(appointments).not_to include non_best_slot
    end
  end

  private

  def stub_appointments(appointments)
    fake_api = instance_double(HackneyApi)

    allow(fake_api).to receive(:list_available_appointments)
      .and_return(appointments)

    allow(HackneyApi).to receive(:new).and_return(fake_api)
  end
end
