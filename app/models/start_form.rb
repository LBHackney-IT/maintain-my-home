class StartForm
  include ActiveModel::Model

  attr_reader :answer

  validates :answer, presence: true

  def initialize(hash = {})
    @answer = hash[:answer]
  end

  def priority_repair?
    answer == 'yes'
  end
end
