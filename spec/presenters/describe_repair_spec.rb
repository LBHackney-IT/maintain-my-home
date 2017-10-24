require 'spec_helper'
require 'active_model'
require 'app/models/describe_repair_form'
require 'app/models/describe_unknown_repair_form'
require 'app/models/repair_params'
require 'app/presenters/describe_repair'

RSpec.describe DescribeRepair do
  describe '#form' do
    context 'when the repair was diagnosed' do
      it 'returns an empty, optional describe repair form' do
        describe_repair = DescribeRepair.new(details: nil, answers: diagnosed_answers)
        expect(describe_repair.form.description).to eq nil
        expect(describe_repair.form.valid?).to eq true
      end

      it 'returns a form with params if provided' do
        form_params = { description: 'Things are broken' }
        describe_repair = DescribeRepair.new(form_params: form_params, details: nil, answers: diagnosed_answers)
        expect(describe_repair.form.description).to eq 'Things are broken'
      end
    end

    context 'when the repair was not diagnosed' do
      it 'returns an empty, required describe repair form' do
        describe_repair = DescribeRepair.new(details: nil, answers: undiagnosed_answers)
        expect(describe_repair.form.description).to eq nil
        expect(describe_repair.form.valid?).to eq false
      end

      it 'returns a form with params if provided' do
        form_params = { description: 'Things are broken' }
        describe_repair = DescribeRepair.new(form_params: form_params, details: nil, answers: diagnosed_answers)
        expect(describe_repair.form.description).to eq 'Things are broken'
      end

      it 'returns a form with errors when the form was invalid' do
        describe_repair = DescribeRepair.new(details: nil, answers: undiagnosed_answers)
        describe_repair.form.valid?
        expect(describe_repair.form.errors).to_not be_empty
      end
    end
  end

  describe '#partial' do
    context 'when the repair was diagnosed' do
      it 'returns the name of a generic optional describe repair partial' do
        describe_repair = DescribeRepair.new(details: nil, answers: diagnosed_answers)
        expect(describe_repair.partial).to eq 'anything_else'
      end
    end

    context 'when the repair was not diagnosed' do
      it 'returns the name of a generic required describe repair partial' do
        describe_repair = DescribeRepair.new(details: nil, answers: undiagnosed_answers)
        expect(describe_repair.partial).to eq 'describe_problem'
      end
    end

    context 'when the repair requires special details' do
      it 'returns the name of a specific describe repair partial' do
        describe_repair = DescribeRepair.new(details: 'bathroom_problem', answers: undiagnosed_answers)
        expect(describe_repair.partial).to eq 'bathroom_problem'
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
