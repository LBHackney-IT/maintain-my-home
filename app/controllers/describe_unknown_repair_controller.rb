class DescribeUnknownRepairController < ApplicationController
  def index; end

  def submit
    redirect_to new_address_search_path
  end
end
