class AddressSearchesController < ApplicationController
  def index
    if selected_answer_store.address?
      @address = selected_answer_store.selected_answers['address']
      repair_params = RepairParams.new(selected_answer_store.selected_answers)
      @diagnosed = repair_params.diagnosed?
      render template: 'address_searches/confirm_address'
    else
      @address_search = AddressSearch.new
    end
  end

  def create
    @address_search = AddressSearch.new(address_search_params[:address_search])

    if @address_search.form.valid?
      @form = AddressForm.new
    else
      render :index
    end
  end

  def destroy
    selected_answer_store.clear_address!
    redirect_to action: :index
  end

  private

  def address_search_params
    params.permit(address_search: [:postcode])
  end
end
