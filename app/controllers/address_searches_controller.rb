class AddressSearchesController < ApplicationController
  def index
    @address_search = AddressSearch.new
  end

  def create
    @address_search = AddressSearch.new(address_search_params[:address_search])
    return render :index unless @address_search.valid?

    address_finder = AddressFinder.new(HackneyApi.new)
    @address_search_results = address_finder.find(@address_search)

    @form = AddressForm.new
  end

  private

  def address_search_params
    params.permit(address_search: [:postcode])
  end
end
