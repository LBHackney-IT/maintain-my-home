require 'spec_helper'
require 'active_support/core_ext/object/blank'
require 'app/presenters/callback'
require 'app/models/repair_params'

RSpec.describe RepairParams do
  describe '#problem_description' do
    it 'fetches the description from answers' do
      answers = {
        'describe_repair' => {
          'description' => 'My bath is broken',
        },
        'last_question' => {
          'question' => 'Is it?',
          'answer' => 'No',
        },
        'problem' => {
          'problem' => 'Bath',
        },
      }
      expect(RepairParams.new(answers).problem_description).to eq "Problem with: Bath\n\nMy bath is broken"
    end

    context 'if no description was provided' do
      it 'posts a default description' do
        answers = {
          'describe_repair' => {
            'description' => '',
          },
          'last_question' => {
            'question' => 'Is it?',
            'answer' => 'No',
          },
        }
        expect(RepairParams.new(answers).problem_description).to eq 'No description given'
      end
    end

    context 'if a room was specified' do
      it 'includes the room in the description' do
        answers = {
          'describe_repair' => {
            'description' => 'My bath is broken',
          },
          'room' => {
            'room' => 'Bathroom',
          },
          'last_question' => {
            'question' => 'Is it?',
            'answer' => 'No',
          },
          'problem' => {
            'problem' => 'Bath',
          },
        }
        expect(RepairParams.new(answers).problem_description).to eq "Room: Bathroom\nProblem with: Bath\n\nMy bath is broken"
      end

      it 'omits the room when it is Other' do
        answers = {
          'describe_repair' => {
            'description' => '',
          },
          'room' => {
            'room' => 'Other',
          },
          'last_question' => {
            'question' => 'Is it?',
            'answer' => 'No',
          },
          'problem' => {
            'problem' => 'Damage to glazing',
          },
        }
        expect(RepairParams.new(answers).problem_description).to eq "Problem with: Damage to glazing\n\nNo description given"
      end
    end

    context 'if a callback was requested' do
      it 'includes the callback info in the description' do
        answers = {
          'describe_repair' => {
            'description' => 'My bath is broken',
          },
          'callback_time' => {
            'callback_time' => ['morning'],
          },
          'last_question' => {
            'question' => 'Is it?',
            'answer' => 'No',
          },
          'problem' => {
            'problem' => 'Bath',
          },
        }

        expect(RepairParams.new(answers).problem_description)
          .to eq "Problem with: Bath\nCallback requested: between 8am and midday\n\nMy bath is broken"
      end
    end
  end

  describe '#property_reference' do
    it 'fetches the property reference from answers' do
      answers = {
        'address' => {
          'propertyReference' => '00034713',
          'address' => 'Ross Court 25',
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

  describe '#diagnosed?' do
    context 'when an SOR code was selected' do
      it 'is true' do
        answers = {
          'diagnosis' => {
            'sor_code' => '002034',
          },
        }
        expect(RepairParams.new(answers).diagnosed?).to eq true
      end
    end

    context 'when no SOR code was selected' do
      it 'is false' do
        answers = {
          'diagnosis' => {
            'next' => 'next_question',
          },
        }
        expect(RepairParams.new(answers).diagnosed?).to eq false
      end
    end

    context 'when there is no diagnosis in the answers' do
      it 'is false' do
        answers = {}
        expect(RepairParams.new(answers).diagnosed?).to eq false
      end
    end
  end
end
