class AddressSearchesController < ApplicationController
  def index
    @address_search = AddressSearchForm.new
    @back = Back.new(controller_name: 'describe_repair')
  end

  def create
    @address_search =
      AddressSearchForm.new(address_search_params[:address_search])
    @back = Back.new(controller_name: 'describe_repair')

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
