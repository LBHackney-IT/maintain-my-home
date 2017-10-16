class Back
  def initialize(controller_name:, routes: Rails.application.routes)
    @controller_name = controller_name
    @helpers = ActionController::Base.helpers
    @routes = routes
  end

  def link
    @helpers.link_to text, @routes.path_for(controller: @controller_name)
  end

  private

  def text
    I18n.t 'back_link'
  end
end
