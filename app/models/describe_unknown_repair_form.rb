class DescribeUnknownRepairForm
  include ActiveModel::Model

  attr_reader :description

  validates :description, presence: true

  def initialize(hash = {})
    @description = hash[:description]
  end
end
