class ScreeningFilterForm
  include ActiveModel::Model

  attr_reader :answer
  attr_reader :choices

  validates :answer, presence: true

  def initialize(hash = {})
    @answer = hash[:answer]
  end

  def choices
    %i[
      communal
      home_adaptations
      multiple_properties
      recent_repair
      none_of_the_above
    ]
  end
end
