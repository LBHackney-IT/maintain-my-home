class AppointmentsController < ApplicationController
  def show
    @appointments = Appointments.new(['Thursday Afternoon (11th October)'])
  end

  def submit
    redirect_to confirmation_path(params[:work_order_reference])
  end

  Appointments = Struct.new(:slots_for_collection)
end
