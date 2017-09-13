class AddressSearch
  include ActiveModel::Model

  attr_accessor :postcode

  validates :postcode, presence: true, postcode: { allow_blank: true }

  def data
    { postcode: postcode }
  end
end

