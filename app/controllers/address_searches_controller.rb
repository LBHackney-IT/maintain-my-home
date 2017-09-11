class AddressSearchesController < ApplicationController
  def show
    @address_search = AddressSearch.new(address_search_params[:address_search])

    @first_visit = address_search_params.empty?
    return if @first_visit

    address_finder = AddressFinder.new(HackneyApi.new)
    @address_search_results = address_finder.find(@address_search)

    @address = Address.new
  end

  private

  def address_search_params
    params.permit(address_search: [:postcode])
  end
end
