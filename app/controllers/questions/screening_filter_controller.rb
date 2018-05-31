module Questions
  class ScreeningFilterController < ApplicationController
    def index
      @form = ScreeningFilterForm.new
    end

    def submit
      @form = ScreeningFilterForm.new(form_params)

      return render :index if @form.invalid?

      next_page = page_mapping[@form.answer] || page_path('emergency_contact')
      redirect_to next_page
    end

    private

    def form_params
      params.require(:screening_filter_form).permit(:answer)
    end

    def page_mapping
      {
        'communal' => page_path('communal'),
        'home_adaptations' => page_path('home_adaptations'),
        'multiple_properties' => page_path('multiple_properties'),
        'recent_repair' => page_path('recent_repair'),
        'none_of_the_above' => questions_path('which_room'),
      }
    end
  end
end
