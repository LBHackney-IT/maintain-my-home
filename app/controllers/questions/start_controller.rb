module Questions
  class StartController < ApplicationController
    def index
      @form = StartForm.new
    end
  end
end
