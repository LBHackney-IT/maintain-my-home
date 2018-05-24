require 'rails_helper'

RSpec.describe Questions::StartController do
  describe '#submit' do
    context 'shows different content based on user choice' do
      it 'shows the gas page' do
        post :submit, params: { start_form: { answer: 'smell_gas' } }

        expect(response).to redirect_to '/pages/gas'
      end

      it 'shows the heating repairs page' do
        post :submit, params: { start_form: { answer: 'no_heating' } }

        expect(response).to redirect_to '/pages/heating_repairs'
      end

      it 'shows the no water repairs page' do
        post :submit, params: { start_form: { answer: 'no_water' } }

        expect(response).to redirect_to '/pages/no_water'
      end

      it 'shows the home adaptations page' do
        post :submit, params: { start_form: { answer: 'home_adaptations' } }

        expect(response).to redirect_to '/pages/home_adaptations'
      end

      it 'shows the which_room question' do
        post :submit, params: { start_form: { answer: 'none_of_the_above' } }

        expect(response).to redirect_to '/questions/which_room'
      end

      it 'shows the standard emergency contact page for other values' do
        post :submit, params: { start_form: { answer: 'xxxx' } }

        expect(response).to redirect_to '/pages/emergency_contact'
      end
    end
  end
end
