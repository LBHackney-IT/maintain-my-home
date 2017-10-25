require 'spec_helper'
require 'app/services/describe_repair_saver'

RSpec.describe DescribeRepairSaver do
  it 'accepts answers' do
    expect { DescribeRepairSaver.new(selected_answer_store: double) }.to_not raise_error
  end

  describe '#save' do
    it 'persists form data to the selected answer store' do
      fake_answer_store = instance_double('SelectedAnswerStore')
      allow(fake_answer_store).to receive(:store_selected_answers)
      fake_form = instance_double('DescribeRepairForm',
                                  valid?: true,
                                  description: 'Things are broken')

      saver = DescribeRepairSaver.new(selected_answer_store: fake_answer_store)
      saver.save(fake_form)

      expect(fake_answer_store)
        .to have_received(:store_selected_answers)
        .with(
          :describe_repair,
          description: 'Things are broken',
        )
    end

    it 'returns true' do
      fake_answer_store = instance_double('SelectedAnswerStore')
      allow(fake_answer_store).to receive(:store_selected_answers)
      fake_form = instance_double('DescribeRepairForm',
                                  valid?: true,
                                  description: 'Things are broken')

      saver = DescribeRepairSaver.new(selected_answer_store: fake_answer_store)
      expect(saver.save(fake_form)).to eq true
    end

    context 'when the form is invalid' do
      it 'does not persist the form data' do
        fake_answer_store = instance_double('SelectedAnswerStore')
        allow(fake_answer_store).to receive(:store_selected_answers)
        fake_form = instance_double('DescribeRepairForm',
                                    valid?: false,
                                    description: '')

        saver = DescribeRepairSaver.new(selected_answer_store: fake_answer_store)
        saver.save(fake_form)

        expect(fake_answer_store).to_not have_received(:store_selected_answers)
      end

      it 'returns false' do
        fake_answer_store = instance_double('SelectedAnswerStore')
        allow(fake_answer_store).to receive(:store_selected_answers)
        fake_form = instance_double('DescribeRepairForm',
                                    valid?: false,
                                    description: '')

        saver = DescribeRepairSaver.new(selected_answer_store: fake_answer_store)
        expect(saver.save(fake_form)).to eq false
      end
    end
  end
end
