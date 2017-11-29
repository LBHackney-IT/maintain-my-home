class ContactDetailsForm
  include ActiveModel::Model

  attr_reader :full_name, :telephone_number

  validates :full_name, presence: true, length: { minimum: 2 }
  validates :telephone_number, presence: true

  validate :telephone_number_format

  def initialize(hash = {})
    @full_name = hash[:full_name]
    @telephone_number = hash[:telephone_number]
  end

  private

  def telephone_number_format
    return unless telephone_number

    telephone_number_only_digits = telephone_number.gsub(/\D/, '')

    if telephone_number_only_digits.size < 10
      errors.add(:telephone_number, :too_short, count: 10)
    elsif telephone_number_only_digits.size > 11
      errors.add(:telephone_number, :too_long, count: 11)
    end
  end
end
