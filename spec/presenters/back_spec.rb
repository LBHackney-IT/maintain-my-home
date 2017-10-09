require 'spec_helper'
require 'app/presenters/back'
require 'action_controller' # required for link_to

RSpec.describe Back do
  describe 'link' do
    it 'generates a link to the previous page' do
      fake_routes = double
      allow(fake_routes)
        .to receive(:path_for)
        .with(controller: 'describe_repair')
        .and_return('/describe-repair')
      allow(I18n)
        .to receive(:t)
        .with('describe_repair', scope: :back_links)
        .and_return('problem details')
      allow(I18n)
        .to receive(:t)
        .with('back_links.prefix', page_description: 'problem details')
        .and_return('Back to problem details')

      expect(Back.new(controller_name: 'describe_repair', routes: fake_routes).link)
        .to eq '<a href="/describe-repair">Back to problem details</a>'
    end
  end
end
