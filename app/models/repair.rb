class Repair
  def initialize(repair_data)
    @repair_data = repair_data
  end

  def request_reference
    @repair_data.fetch('repairRequestReference')
  end

  def work_order_reference
    return nil unless @repair_data.key?('workOrders')

    @repair_data.fetch('workOrders')&.first&.fetch('workOrderReference')
  end

  def sor_code
    return nil unless @repair_data.key?('workOrders')

    @repair_data.fetch('workOrders')&.first&.fetch('sorCode')
  end

  def supplier_reference
    return nil unless @repair_data.key?('workOrders')
    @repair_data.fetch('workOrders')&.first&.fetch('supplierRef')
  end

  def priority
    @repair_data.fetch('priority')
  end

  def attributes
    {
      requested_at: Time.zone.now.strftime('%F %R'),
      request_reference: request_reference,
      sor_code: sor_code,
      supplier_reference: supplier_reference,
      priority: priority
    }
  end
end
