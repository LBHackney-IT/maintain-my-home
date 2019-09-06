class FindCautionaryContact
  attr_accessor :api, :property_reference

  def initialize(api: HackneyApi.new, property_reference:)
    self.api = api
    self.property_reference = property_reference
  end

  def present?
    result = api.get_cautionary_contacts(property_reference: property_reference)
    return true if caution?(api_result: result)

    false
  end

  def not_present?
    !present?
  end

  private

  def caution?(api_result: {})
    alert_codes = api_result.dig('results', 'alertCodes') || []
    caller_notes = api_result.dig('results', 'callerNotes') || []

    values_for_no_caution = [[nil], []]
    
    !values_for_no_caution.include?(alert_codes) || !values_for_no_caution.include?(caller_notes)
  end
end
