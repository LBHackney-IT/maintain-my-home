class PostcodeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if valid_postcode?(value)
    message = (options[:message] || "doesn't seem to be valid")
    record.errors[attribute] << message
  end

  private

  def valid_postcode?(postcode)
    # Adapted from https://gist.github.com/mudge/163332
    # rubocop:disable LineLength
    postcode =~ /^\s*((GIR\s*0AA)|((([A-PR-UWYZ][0-9]{1,2})|(([A-PR-UWYZ][A-HK-Y][0-9]{1,2})|(([A-PR-UWYZ][0-9][A-HJKSTUW])|([A-PR-UWYZ][A-HK-Y][0-9][ABEHMNPRVWXY]))))\s*[0-9][ABD-HJLNP-UW-Z]{2}))\s*$/i
  end
end
