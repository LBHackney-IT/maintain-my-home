class QuestionForm
  include ActiveModel::Model

  attr_reader :answer

  validates :answer, presence: true

  def initialize(hash = {})
    @answer = hash[:answer]
  end
end
