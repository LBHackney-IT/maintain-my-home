module Questions
  class StartController < ApplicationController
    def index
      @form = StartForm.new
    end

    def submit
      @form = StartForm.new(start_form_params)

      return render :index unless @form.valid?
      return redirect_to emergency_contact_path if @form.priority_repair?

      redirect_to describe_repair_path
    end

    private

    def start_form_params
      params.require(:start_form).permit!
    end
  end
end
