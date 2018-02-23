class DescribeRepairForm
  include ActiveModel::Model

  attr_accessor :description

  validates :description, presence: true, length: { maximum: 500 }
end
