class AddressFinder
  def find(_form)
    [
      Result.new('P01234', 'Flat 1, 8 Hoxton Square, N1 6NU'),
    ]
  end

  Result = Struct.new(:property_reference, :short_address)
end
