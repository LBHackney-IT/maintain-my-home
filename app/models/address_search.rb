class AddressSearch
  include ActiveModel::Model

  attr_accessor :postcode

  def data
    { postcode: postcode }
  end
end
