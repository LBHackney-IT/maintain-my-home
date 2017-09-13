class AddressSearchesController < ApplicationController
  def show
    @address_search = AddressSearch.new(address_search_params[:address_search])

    first_visit = address_search_params.empty?
    @show_results = !first_visit && @address_search.valid?

    return unless @show_results

    address_finder = AddressFinder.new(HackneyApi.new)
    @address_search_results = address_finder.find(@address_search)

    @address = Address.new
  end

  private

  def address_search_params
    params.permit(address_search: [:postcode])
  end
end
