class ConfirmationsController < ApplicationController
  def show
    @confirmation = Confirmation.new(params[:id])
  end

  Confirmation = Struct.new(:repair_request_id)
end
