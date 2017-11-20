class AddressFinder
  def initialize(api = HackneyApi.new)
    @api = api
  end

  def find(form)
    properties = @api.list_properties(postcode: form.data[:postcode])
    properties.map do |property|
      Property.new(
        property['property_reference'],
        property['address']
      )
    end
  end

  Property = Struct.new(:property_reference, :address)
end
