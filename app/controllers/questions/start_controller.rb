module Questions
  class StartController < ApplicationController
    def index
      @form = StartForm.new
    end

    def submit
      @form = StartForm.new(start_form_params)

      return render :index unless @form.valid?

      if @form.priority_repair?
        return redirect_to page_path('emergency_contact')
      end

      redirect_to questions_path('location')
    end

    private

    def start_form_params
      params.require(:start_form).permit!
    end
  end
end
