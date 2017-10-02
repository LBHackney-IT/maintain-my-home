module Questions
  class StartController < ApplicationController
    def index
      @form = StartForm.new
    end

    def submit
      @form = StartForm.new(start_form_params)

      unless @form.valid?
        flash.now[:alert] = @form.errors.full_messages
        return render :index
      end

      return redirect_to emergency_contact_path if @form.priority_repair?

      render :submit
    end

    private

    def start_form_params
      params.require(:start_form).permit!
    end
  end
end
