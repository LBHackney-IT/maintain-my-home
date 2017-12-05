require 'spec_helper'
require 'app/services/question_saver'

RSpec.describe QuestionSaver do
  describe '.save' do
    context 'when there is an SOR code on the question' do
      it 'persists form data to the selected answer store' do
        fake_question = instance_double('Question', id: 'start', title: 'is it?')
        allow(fake_question).to receive(:answer_data).with('Yes').and_return('sor_code' => '012345')
        fake_answer_store = instance_double('SelectedAnswerStore')
        allow(fake_answer_store).to receive(:store_selected_answers)
        fake_form = instance_double('QuestionForm',
                                    valid?: true,
                                    answer: 'Yes')

        saver = QuestionSaver.new(question: fake_question, selected_answer_store: fake_answer_store)
        saver.save(fake_form)

        expect(fake_answer_store)
          .to have_received(:store_selected_answers)
          .with(
            :diagnosis,
            sor_code: '012345',
          )
      end

      it 'returns true' do
        fake_question = instance_double('Question', id: 'start', title: 'is it?')
        allow(fake_question).to receive(:answer_data).with('Yes').and_return('sor_code' => '012345')
        fake_answer_store = instance_double('SelectedAnswerStore')
        allow(fake_answer_store).to receive(:store_selected_answers)
        fake_form = instance_double('QuestionForm',
                                    valid?: true,
                                    answer: 'Yes')

        saver = QuestionSaver.new(question: fake_question, selected_answer_store: fake_answer_store)
        expect(saver.save(fake_form)).to eq true
      end
    end

    context 'when there is a room on the question' do
      it 'persists form data to the selected answer store' do
        fake_question = instance_double('Question', id: 'which_room', title: 'is it?')
        allow(fake_question).to receive(:answer_data).with('Kitchen').and_return({})
        fake_answer_store = instance_double('SelectedAnswerStore')
        allow(fake_answer_store).to receive(:store_selected_answers)
        fake_form = instance_double('QuestionForm',
                                    valid?: true,
                                    answer: 'Kitchen')

        saver = QuestionSaver.new(question: fake_question, selected_answer_store: fake_answer_store)
        saver.save(fake_form)

        expect(fake_answer_store)
          .to have_received(:store_selected_answers)
          .with(
            :room,
            room: 'Kitchen',
          )
      end
    end

    context 'when the question is the last in the tree (explicit description)' do
      it 'persists form data to the selected answer store' do
        fake_question = instance_double('Question', id: 'broken_tap', title: 'Is your tap broken?')
        allow(fake_question).to receive(:answer_data)
          .with('Yes')
          .and_return('text' => 'Yes', 'desc' => 'kitchen_problem')
        fake_answer_store = instance_double('SelectedAnswerStore')
        allow(fake_answer_store).to receive(:store_selected_answers)
        fake_form = instance_double('QuestionForm',
                                    valid?: true,
                                    answer: 'Yes')

        saver = QuestionSaver.new(question: fake_question, selected_answer_store: fake_answer_store)
        saver.save(fake_form)

        expect(fake_answer_store)
          .to have_received(:store_selected_answers)
          .with(
            :last_question,
            question: 'Is your tap broken?',
            answer: 'Yes',
          )
      end
    end

    context 'when the question is the last in the tree (implicit description)' do
      it 'persists form data to the selected answer store' do
        fake_question = instance_double('Question', id: 'broken_tap', title: 'Is your tap broken?')
        allow(fake_question).to receive(:answer_data)
          .with('Yes')
          .and_return('text' => 'Yes', 'sor_code' => '01234567') # No explicit next, desc or page, so must be the last
        fake_answer_store = instance_double('SelectedAnswerStore')
        allow(fake_answer_store).to receive(:store_selected_answers)
        fake_form = instance_double('QuestionForm',
                                    valid?: true,
                                    answer: 'Yes')

        saver = QuestionSaver.new(question: fake_question, selected_answer_store: fake_answer_store)
        saver.save(fake_form)

        expect(fake_answer_store)
          .to have_received(:store_selected_answers)
          .with(
            :last_question,
            question: 'Is your tap broken?',
            answer: 'Yes',
          )
      end
    end

    context 'when there is no SOR code on the question' do
      it "doesn't change the selected answer store" do
        fake_question = instance_double('Question', id: 'start')
        allow(fake_question).to receive(:answer_data).with('Yes').and_return('next' => 'suggested_countermeasures')
        fake_answer_store = instance_double('SelectedAnswerStore')
        allow(fake_answer_store).to receive(:store_selected_answers)
        fake_form = instance_double('QuestionForm',
                                    valid?: true,
                                    answer: 'Yes')

        saver = QuestionSaver.new(question: fake_question, selected_answer_store: fake_answer_store)
        saver.save(fake_form)

        expect(fake_answer_store).to_not have_received(:store_selected_answers)
      end

      it 'returns true' do
        # ...because even though we're not doing anything, it's not a failure
        # and the caller shouldn't have to care
        fake_question = instance_double('Question', id: 'start')
        allow(fake_question).to receive(:answer_data).with('Yes').and_return('next' => 'suggested_countermeasures')
        fake_answer_store = instance_double('SelectedAnswerStore')
        allow(fake_answer_store).to receive(:store_selected_answers)
        fake_form = instance_double('QuestionForm',
                                    valid?: true,
                                    answer: 'Yes')

        saver = QuestionSaver.new(question: fake_question, selected_answer_store: fake_answer_store)
        expect(saver.save(fake_form)).to eq true
      end
    end

    context 'when the form is invalid' do
      it 'does not persist the form data' do
        fake_answer_store = instance_double('SelectedAnswerStore')
        allow(fake_answer_store).to receive(:store_selected_answers)
        fake_form = instance_double('QuestionForm',
                                    valid?: false,
                                    answer: '')

        saver = QuestionSaver.new(question: double, selected_answer_store: fake_answer_store)
        saver.save(fake_form)

        expect(fake_answer_store).to_not have_received(:store_selected_answers)
      end

      it 'returns false' do
        fake_answer_store = instance_double('SelectedAnswerStore')
        allow(fake_answer_store).to receive(:store_selected_answers)
        fake_form = instance_double('QuestionForm',
                                    valid?: false,
                                    answer: '')

        saver = QuestionSaver.new(question: double, selected_answer_store: fake_answer_store)
        expect(saver.save(fake_form)).to eq false
      end
    end
  end
end
