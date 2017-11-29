class DescribeUnknownRepairForm
  include ActiveModel::Model

  attr_reader :description

  validates :description, presence: true, length: { maximum: 500 }

  def initialize(hash = {})
    @description = hash[:description]
  end
end
