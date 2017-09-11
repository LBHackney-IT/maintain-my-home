class HackneyApi
  def initialize(json_api = JsonApi.new)
    @json_api = json_api
  end

  def list_properties(postcode:)
    @json_api.get('properties?postcode=' + postcode)
  end
end
