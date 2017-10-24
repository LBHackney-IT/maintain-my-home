class AppointmentsController < ApplicationController
  def show
    @form = AppointmentForm.new
    @appointments = available_appointments
  end

  def submit
    @form = AppointmentForm.new(appointment_form_params)

    if @form.invalid?
      @appointments = available_appointments
      return render :show
    end

    # TODO: Book appointment

    redirect_to confirmation_path(params[:repair_request_reference])
  end

  private

  def appointment_form_params
    params.require(:appointment_form).permit(:appointment_id)
  end

  def work_order_reference
    Repair.new(
      HackneyApi.new.get_repair(
        repair_request_reference: params[:repair_request_reference]
      )
    ).work_order_reference
  end

  def available_appointments
    appointments = HackneyApi.new.list_available_appointments(
      work_order_reference: work_order_reference
    )

    appointments.map { |a| AppointmentPresenter.new(a) }
  end
end
