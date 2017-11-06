module CapybaraHelpers
  def choose_radio_button(label)
    find(:label, text: label).click
  end

  def stub_diagnosis_question(answers:, question: 'Dummy question', id: 'location')
    fake_question_set = instance_double(QuestionSet)
    allow(fake_question_set)
      .to receive(:find)
      .with(id)
      .and_return(Question.new('id' => id, 'question' => question, 'answers' => answers))
    allow(QuestionSet).to receive(:new).and_return(fake_question_set)
  end
end
