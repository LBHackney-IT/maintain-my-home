class DescribeRepairForm
  include ActiveModel::Model

  attr_accessor :description

  validates :description, length: { maximum: 500 }
end
