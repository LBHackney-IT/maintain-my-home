class StartForm
  include ActiveModel::Model

  attr_accessor :priority_repair

  validate :mandatory_fields_present

  def priority_repair?
    priority_repair == 'yes'
  end

  private

  def mandatory_fields_present
    return if priority_repair.present?

    errors.add(:base, I18n.t('errors.no_selection'))
  end
end
