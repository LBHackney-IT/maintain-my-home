require 'spec_helper'
require 'active_support/core_ext/object/blank'
require 'app/models/repair_params'

RSpec.describe RepairParams do
  describe '#problem' do
    it 'fetches the description from answers' do
      answers = {
        'describe_repair' => {
          'description' => 'My bath is broken',
        },
      }
      expect(RepairParams.new(answers).problem).to eq 'My bath is broken'
    end

    context 'if no description was provided' do
      it 'posts a default description' do
        answers = {
          'describe_repair' => {
            'description' => '',
          },
        }
        expect(RepairParams.new(answers).problem).to eq 'n/a'
      end
    end
  end

  describe '#property_reference' do
    it 'fetches the property reference from answers' do
      answers = {
        'address' => {
          'property_reference' => '00034713',
          'short_address' => 'Ross Court 25',
          'postcode' => 'E5 8TE',
        },
      }
      expect(RepairParams.new(answers).property_reference).to eq '00034713'
    end
  end

  describe '#priority' do
    it 'is always "Normal"' do
      answers = {}
      expect(RepairParams.new(answers).priority).to eq 'N'
    end
  end

  describe '#sor_code' do
    it 'fetches the SOR code from answers' do
      answers = {
        'diagnosis' => {
          'sor_code' => '002034',
        },
      }
      expect(RepairParams.new(answers).sor_code).to eq '002034'
    end

    context 'when there is no sor_code in the diagnosis' do
      it 'is nil' do
        answers = {
          'diagnosis' => {
            'next' => 'next_question',
          },
        }
        expect(RepairParams.new(answers).sor_code).to be_nil
      end
    end

    context 'when there is no diagnosis in the answers' do
      it 'is nil' do
        answers = {}
        expect(RepairParams.new(answers).sor_code).to be_nil
      end
    end
  end
end
