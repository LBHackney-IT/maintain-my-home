class HackneyApi
  def initialize(json_api = JsonApi.new)
    @json_api = json_api
  end

  def list_properties(postcode:)
    response = @json_api.get('v1/properties?postcode=' + postcode)
    response.fetch('results')
  end

  def get_property(property_reference:)
    @json_api.get('v1/properties/' + property_reference)
  end

  def create_repair(repair_params)
    @json_api.post('repairs', repair_params)
  end

  def get_repair(repair_request_reference:)
    @json_api.get('repairs/' + repair_request_reference)
  end

  def list_available_appointments(work_order_reference:)
    @json_api.get(
      'work_orders/' + work_order_reference + '/appointments'
    )
  end

  def book_appointment(work_order_reference:, begin_date:, end_date:)
    @json_api.post(
      'work_orders/' + work_order_reference + '/appointments',
      beginDate: begin_date,
      endDate: end_date
    )
  end
end
