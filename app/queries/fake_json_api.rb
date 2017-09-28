class FakeJsonApi
  def get(path)
    case path
    when /^properties\?postcode=/
      fake_property_search_results
    when %r{^properties\/}
      fake_property
    else
      {}
    end
  end

  private

  def fake_property_search_results
    [
      {
        'property_reference' => 'abc123',
        'short_address' => '220 Aardvark Road, A1 1AA',
      },
      {
        'property_reference' => 'zxc987',
        'short_address' => '221B Aardvark Road, A1 1AA',
      },
    ]
  end

  def fake_property
    {
      'property_reference' => 'zxc987',
      'short_address' => '221B Aardvark Road, A1 1AA',
      'uprn' => '123456789',
    }
  end
end
