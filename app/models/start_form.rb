class StartForm
  include ActiveModel::Model

  attr_reader :answer

  validates :answer, presence: true

  def initialize(hash = {})
    @answer = hash[:answer]
  end

  def choices
    %i[
      smell_gas
      no_heating
      no_water
      no_power
      water_leak
      not_secure_access
      home_adaptations
      none_of_the_above
    ]
  end
end
