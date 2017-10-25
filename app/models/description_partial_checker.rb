class DescriptionPartialChecker
  def initialize(lookup_context:)
    @lookup_context = lookup_context
  end

  def exists?(partial_name)
    return false if partial_name.nil?
    @lookup_context.exists?(partial_name, 'describe_repair', true)
  end
end
