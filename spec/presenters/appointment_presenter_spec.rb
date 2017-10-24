require 'rails_helper'

RSpec.describe AppointmentPresenter do
  it 'is renderable' do
    expect(AppointmentPresenter.new.to_partial_path).to eq '/confirmations/appointment'
  end

  describe '#appointment_id' do
    it 'returns the begin and end dates concatenated together' do
      presenter = AppointmentPresenter.new(
        'beginDate' => '2017-12-25T12:00:00Z',
        'endDate' => '2017-12-25T16:45:00Z',
        'bestSlot' => true
      )

      expect(presenter.appointment_id).to eql '2017-12-25T12:00:00Z|2017-12-25T16:45:00Z'
    end
  end

  describe '#description' do
    it 'returns the appointment slot in a human-readable format' do
      presenter = AppointmentPresenter.new(
        'beginDate' => '2017-12-25T12:00:00Z',
        'endDate' => '2017-12-25T16:45:00Z',
        'bestSlot' => true
      )

      expect(presenter.description).to eql 'Monday 12:00pm-4:45pm (25th December)'
    end
  end
end
