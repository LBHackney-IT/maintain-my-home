class PagesController < ApplicationController
  def address_isnt_here
    @back = Back.new(controller_name: 'address_searches')
  end

  def emergency_contact
    @back = Back.new(controller_name: 'questions/start')
  end
end
