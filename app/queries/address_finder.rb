class AddressFinder
  def initialize(api)
    @api = api
  end

  def find(form)
    properties = @api.list_properties(form.data[:postcode])
    properties.map do |property|
      Property.new(
        property['property_reference'],
        property['short_address']
      )
    end
  end

  Property = Struct.new(:property_reference, :short_address)
end
