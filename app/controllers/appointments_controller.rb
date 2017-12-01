class AppointmentsController < ApplicationController
  def show
    @form = AppointmentForm.new
    @appointments = available_appointments
    @work_order_reference = work_order_reference
  end

  def submit
    @form = AppointmentForm.new(appointment_form_params)

    if @form.invalid?
      @appointments = available_appointments
      @work_order_reference = work_order_reference
      return render :show
    end

    book_appointment_save_into_answer_store

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
    AppointmentFetcher
      .new
      .call(work_order_reference: work_order_reference)
      .map { |appointment| AppointmentPresenter.new(appointment) }
  end

  def book_appointment_save_into_answer_store
    appointment = HackneyApi.new.book_appointment(
      work_order_reference: work_order_reference,
      begin_date: @form.begin_date,
      end_date: @form.end_date
    )

    selected_answer_store.store_selected_answers(
      'appointment', appointment
    )
  end
end
