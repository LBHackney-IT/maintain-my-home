class AddressForm
  include ActiveModel::Model

  attr_accessor :property_reference, :postcode

  validates :property_reference, presence: true

  def address_isnt_here?
    property_reference == 'address_isnt_here'
  end
end
