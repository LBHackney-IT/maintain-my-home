class DescribeRepairController < ApplicationController
  def index; end

  def submit
    redirect_to address_search_path
  end
end
