class StartForm
  include ActiveModel::Model

  attr_reader :answer
  attr_reader :choices

  validates :answer, presence: true

  def initialize(hash = {})
    @answer = hash[:answer]
  end

  def choices
    %i[
      smell_gas no_heating no_water no_power water_leak water_leak_electrics
      not_secure_access exposed_wiring alarm_beeping none_of_the_above
    ]
  end
end
