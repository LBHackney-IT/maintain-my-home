require 'spec_helper'
require 'active_model'
require 'app/models/describe_repair_form'
require 'app/models/describe_unknown_repair_form'
require 'app/models/repair_params'
require 'app/presenters/describe_repair'

RSpec.describe DescribeRepair do
  describe '#form' do
    context 'when the repair was diagnosed' do
      it 'returns an empty, required describe repair form' do
        describe_repair = DescribeRepair.new(details: nil, answers: diagnosed_answers, partial_checker: double)
        expect(describe_repair.form.description).to eq nil
        expect(describe_repair.form.valid?).to eq false
      end

      it 'returns a form with params if provided' do
        form_params = { description: 'Things are broken' }
        describe_repair = DescribeRepair.new(form_params: form_params, details: nil, answers: diagnosed_answers, partial_checker: double)
        expect(describe_repair.form.description).to eq 'Things are broken'
      end
    end

    context 'when the repair was not diagnosed' do
      it 'returns an empty, required describe repair form' do
        describe_repair = DescribeRepair.new(details: nil, answers: undiagnosed_answers, partial_checker: double)
        expect(describe_repair.form.description).to eq nil
        expect(describe_repair.form.valid?).to eq false
      end

      it 'returns a form with params if provided' do
        form_params = { description: 'Things are broken' }
        describe_repair = DescribeRepair.new(form_params: form_params, details: nil, answers: diagnosed_answers, partial_checker: double)
        expect(describe_repair.form.description).to eq 'Things are broken'
      end

      it 'returns a form with errors when the form was invalid' do
        describe_repair = DescribeRepair.new(details: nil, answers: undiagnosed_answers, partial_checker: double)
        describe_repair.form.valid?
        expect(describe_repair.form.errors).to_not be_empty
      end
    end
  end

  describe '#partial' do
    context 'when the repair was diagnosed' do
      it 'defaults to a generic optional describe repair partial' do
        fake_partial_checker = double('DescriptionPartialChecker')
        allow(fake_partial_checker).to receive(:exists?)
          .with(nil)
          .and_return(false)
        describe_repair = DescribeRepair.new(details: nil, answers: diagnosed_answers, partial_checker: fake_partial_checker)
        expect(describe_repair.partial).to eq 'anything_else'
      end

      it 'returns the name of a specific describe repair partial if provided' do
        fake_partial_checker = double('DescriptionPartialChecker')
        allow(fake_partial_checker).to receive(:exists?)
          .with('bathroom_problem')
          .and_return(true)
        describe_repair = DescribeRepair.new(details: 'bathroom_problem', answers: diagnosed_answers, partial_checker: fake_partial_checker)
        expect(describe_repair.partial).to eq 'bathroom_problem'
      end
    end

    context 'when the repair was not diagnosed' do
      it 'defaults to a generic required describe repair partial' do
        fake_partial_checker = double('DescriptionPartialChecker')
        allow(fake_partial_checker).to receive(:exists?)
          .with(nil)
          .and_return(false)
        describe_repair = DescribeRepair.new(details: nil, answers: undiagnosed_answers, partial_checker: fake_partial_checker)
        expect(describe_repair.partial).to eq 'describe_problem'
      end

      it 'returns the name of a specific describe repair partial if provided' do
        fake_partial_checker = double('DescriptionPartialChecker')
        allow(fake_partial_checker).to receive(:exists?)
          .with('bathroom_problem')
          .and_return(true)
        describe_repair = DescribeRepair.new(details: 'bathroom_problem', answers: undiagnosed_answers, partial_checker: fake_partial_checker)
        expect(describe_repair.partial).to eq 'bathroom_problem'
      end
    end

    context 'when the special partial does not exist' do
      it 'returns the name of a generic required describe repair partial' do
        fake_partial_checker = double('DescriptionPartialChecker')
        allow(fake_partial_checker).to receive(:exists?)
          .with('evil_attacker')
          .and_return(false)
        describe_repair = DescribeRepair.new(details: 'evil_attacker', answers: undiagnosed_answers, partial_checker: fake_partial_checker)
        expect(describe_repair.partial).to eq 'describe_problem'
      end
    end
  end

  def diagnosed_answers
    {
      'diagnosis' => {
        'sor_code' => '012345',
      },
    }
  end

  def undiagnosed_answers
    {}
  end
end
