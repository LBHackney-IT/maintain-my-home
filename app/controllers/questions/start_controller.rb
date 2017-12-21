module Questions
  class StartController < ApplicationController
    def index
      reset_session

      @form = StartForm.new
    end

    def submit
      @form = StartForm.new(start_form_params)

      return render :index if @form.invalid?

      next_page = case @form.answer
                  when 'smell_gas'
                    page_path('gas')
                  when 'no_heating'
                    page_path('heating_repairs')
                  when 'home_adaptations'
                    page_path('home_adaptations')
                  when 'none_of_the_above'
                    questions_path('which_room')
                  else
                    page_path('emergency_contact')
                  end

      redirect_to next_page
    end

    private

    def start_form_params
      params.require(:start_form).permit(:answer)
    end
  end
end
