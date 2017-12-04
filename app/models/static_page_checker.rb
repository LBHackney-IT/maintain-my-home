class StaticPageChecker
  def initialize(lookup_context:)
    @lookup_context = lookup_context
  end

  def exists?(page_name)
    return false if page_name.nil?
    @lookup_context.exists?(page_name, 'pages')
  end
end
