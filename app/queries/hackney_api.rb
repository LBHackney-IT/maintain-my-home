class HackneyApi
  def initialize(json_api = JsonApi.new)
    @json_api = json_api
  end

  def list_properties(postcode:)
    @json_api.get('properties?postcode=' + postcode)
  end

  def get_property(property_reference:)
    @json_api.get('properties/' + property_reference)
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
end
