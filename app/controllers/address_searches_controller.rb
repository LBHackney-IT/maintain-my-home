class AddressSearchesController < ApplicationController
  def show
    @address_search = AddressSearch.new
  end

  def update
    @address_search = AddressSearch.new(address_search_params[:address_search])

    unless @address_search.valid?
      render :show
      return
    end

    address_finder = AddressFinder.new(HackneyApi.new)
    @address_search_results = address_finder.find(@address_search)

    @address = Address.new
  end

  private

  def address_search_params
    params.permit(address_search: [:postcode])
  end
end
