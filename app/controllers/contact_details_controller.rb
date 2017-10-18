class ContactDetailsController < ApplicationController
  def index
    @form = ContactDetailsForm.new
  end

  def submit
    redirect_to confirmation_path('WORK_ORDER_REFERENCE')
  end
end
