class AppointmentFetcher
  def call(work_order_reference:)
    @work_order_reference = work_order_reference

    available_appointments
  end

  private

  def available_appointments
    HackneyApi.new.list_available_appointments(
      work_order_reference: @work_order_reference
    )
  end
end
