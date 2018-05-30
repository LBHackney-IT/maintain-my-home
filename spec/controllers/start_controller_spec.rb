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

      it 'shows the exposed wiring page' do
        post :submit, params: { start_form: { answer: 'exposed_wiring' } }

        expect(response).to redirect_to '/pages/electrical_hazard_emergency'
      end

      it 'shows the water leak electrics page' do
        post :submit, params: { start_form: { answer: 'water_leak_electrics' } }

        expect(response).to redirect_to '/pages/electrical_hazard_emergency'
      end

      it 'shows the alarm beeping page' do
        post :submit, params: { start_form: { answer: 'alarm_beeping' } }

        expect(response).to redirect_to '/pages/alarm_beeping_emergency'
      end

      it 'shows the screening filter question' do
        post :submit, params: { start_form: { answer: 'none_of_the_above' } }

        expect(response).to redirect_to '/questions/screening_filter'
      end

      it 'shows the standard emergency contact page for other values' do
        post :submit, params: { start_form: { answer: 'xxxx' } }

        expect(response).to redirect_to '/pages/emergency_contact'
      end
    end
  end
end
