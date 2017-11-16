require 'flipper/adapters/memory'

RSpec.configure do |config|
  config.before(:each) do
    # This will be cleared between examples, so there is no need to include an after block
    # if you are setting a flag in a before block
    allow(App).to receive(:flipper).and_return(Flipper.new(Flipper::Adapters::Memory.new))
  end
end
