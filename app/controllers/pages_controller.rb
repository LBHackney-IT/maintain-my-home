class PagesController < ApplicationController
  def address_isnt_here; end

  def emergency_contact
    @back = Back.new(controller_name: 'questions/start')
  end
end
