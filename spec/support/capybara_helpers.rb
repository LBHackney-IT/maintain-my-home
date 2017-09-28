module CapybaraHelpers
  def choose_radio_button(label)
    find(:label, text: label).click
  end
end
