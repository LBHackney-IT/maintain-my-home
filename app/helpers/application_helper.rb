module ApplicationHelper
  def back_link
    tag.span class: 'js-back-link', data: { text: t('back_link') }
  end

  def telephone_number(number)
    tag.span itemprop: 'telephone' do
      link_to number, "tel:#{number.gsub(/\s+/, '')}"
    end
  end

  def repairs_contact_centre_telephone_number
    telephone_number('020 8356 3691')
  end

  def repairs_emergency_telephone_number
    # NOTE: This is the same as the main RCC number
    # but redirects to another number out of hours
    telephone_number('020 8356 3691')
  end

  def gas_emergency_telephone_number
    telephone_number('0800 111 999')
  end

  def electricity_emergency_telephone_number
    # TODO: this is the 'temporary emergency number'
    # should possibly be the national power network
    # number instead? '0800 028 0247'
    telephone_number('020 8356 2300')
  end

  def water_emergency_telephone_number
    telephone_number('0800 714 614')
  end
end
