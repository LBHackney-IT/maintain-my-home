class DescribeRepairController < ApplicationController
  def index
    @back = Back.new(controller_name: 'questions/start')
  end

  def submit
    redirect_to address_search_path
  end
end
