require 'spec_helper'
require 'app/models/selected_answer_store'

RSpec.describe SelectedAnswerStore do
  it 'should store answers for a given stage' do
    session = {}
    answers = {
      'property_ref' => 'bsg108',
    }
    store = SelectedAnswerStore.new(session)

    store.store_selected_answers('address', answers)

    expect(session[:selected_answers]).to eql('address' => answers)
    expect(store.selected_answers).to eql('address' => answers)
  end

  it 'should overwrite stale answers with new ones' do
    session = {}
    old_answers = {
      'property_ref' => 'adh389',
      'address' => 'Flat 1, 35 Church Walk, N16 8QR',
    }
    new_answers = {
      'property_ref' => 'bsg108',
    }

    store = SelectedAnswerStore.new(session)
    store.store_selected_answers('address', old_answers)
    store.store_selected_answers('address', new_answers)

    expect(session[:selected_answers]).to eql('address' => new_answers)
    expect(store.selected_answers).to eql('address' => new_answers)
  end
end
