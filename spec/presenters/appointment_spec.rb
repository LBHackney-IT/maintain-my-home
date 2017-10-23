require 'spec_helper'
require 'app/presenters/appointment'

RSpec.describe Appointment do
  it 'is renderable' do
    expect(Appointment.new.to_partial_path).to eq '/confirmations/appointment'
  end
end
