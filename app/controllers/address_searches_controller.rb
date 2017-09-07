class AddressSearchesController < ApplicationController
  def show
    @address_search = AddressSearch.new
    @address = Address.new
    @address_search_results = AddressFinder.new.find(@address_search)
  end
end
