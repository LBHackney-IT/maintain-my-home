class AddressSearchesController < ApplicationController
  def index
    @address_search = AddressSearch.new
  end

  def create
    @address_search = AddressSearch.new(address_search_params[:address_search])

    if @address_search.form.valid?
      @form = AddressForm.new
    else
      render :index
    end
  end

  private

  def address_search_params
    params.permit(address_search: [:postcode])
  end
end
