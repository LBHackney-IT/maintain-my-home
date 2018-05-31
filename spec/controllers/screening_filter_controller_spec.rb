require 'rails_helper'

RSpec.describe Questions::ScreeningFilterController do
  describe '#submit' do
    context 'shows different content based on user choice' do
      it 'shows the communal page' do
        post :submit, params: { screening_filter_form: { answer: 'communal' } }

        expect(response).to redirect_to '/pages/communal'
      end

      it 'shows the home adaptations page' do
        post :submit, params: { screening_filter_form: { answer: 'home_adaptations' } }

        expect(response).to redirect_to '/pages/home_adaptations'
      end

      it 'shows the multiple properties page' do
        post :submit, params: { screening_filter_form: { answer: 'multiple_properties' } }

        expect(response).to redirect_to '/pages/multiple_properties'
      end

      it 'shows the recent repair page' do
        post :submit, params: { screening_filter_form: { answer: 'recent_repair' } }

        expect(response).to redirect_to '/pages/recent_repair'
      end

      it 'shows the which_room question' do
        post :submit, params: { screening_filter_form: { answer: 'none_of_the_above' } }

        expect(response).to redirect_to '/questions/which_room'
      end

      it 'shows the standard emergency contact page for other values' do
        post :submit, params: { screening_filter_form: { answer: 'xxxx' } }

        expect(response).to redirect_to '/pages/emergency_contact'
      end
    end
  end
end
