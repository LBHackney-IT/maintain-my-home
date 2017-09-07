class AddressSearchesController < ApplicationController
  def show
    @address_search = AddressSearch.new
    @address = Address.new
    address_finder = AddressFinder.new(HackneyApi.new)
    @address_search_results = address_finder.find(@address_search)
  end
end
