class Repair
  def initialize(repair_data)
    @repair_data = repair_data
  end

  def request_reference
    @repair_data.fetch('repairRequestReference')
  end

  def work_order_reference
    @repair_data['orderReference']
  end
end
