class DescribeRepairSaver
  def initialize(selected_answer_store:)
    @selected_answer_store = selected_answer_store
  end

  def save(form)
    if form.valid?
      persist_answers(form)
      true
    else
      false
    end
  end

  private

  def persist_answers(form)
    @selected_answer_store.store_selected_answers(
      :describe_repair,
      description: form.description,
    )
  end
end
