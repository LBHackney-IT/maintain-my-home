class AddressSearchForm
  include ActiveModel::Model

  attr_accessor :postcode

  validates :postcode, presence: true, postcode: { allow_blank: true }

  def data
    { postcode: normalised_postcode }
  end

  private

  def normalised_postcode
    postcode.strip.gsub(/\s+/, '').insert(-4, ' ').upcase
  end
end
