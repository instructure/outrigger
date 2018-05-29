require 'spec_helper'

class TestProxy
  include Outrigger::TaggableProxy
  attr_accessor :migration
end

describe Outrigger::TaggableProxy do
  it 'it should delegate tags to the migration' do
    proxy = TestProxy.new
    proxy.migration = PreDeployMigration.new

    expect(proxy.tags).to eq([:predeploy])
  end
end
