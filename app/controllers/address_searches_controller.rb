class AddressSearchesController < ApplicationController
  def show
    @address_search = AddressSearch.new
    @address = Address.new
  end
end
