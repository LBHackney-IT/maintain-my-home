require 'rails_helper'

RSpec.describe QuestionForm do
  describe 'validations' do
    it 'is invalid when not answered' do
      form = QuestionForm.new
      form.valid?

      expect(form.errors.details[:answer]).to include(error: :blank)
    end
  end
end
