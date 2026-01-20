# frozen_string_literal: true

class TestProxy
  include Outrigger::TaggableProxy

  attr_accessor :migration
end

describe Outrigger::TaggableProxy do
  it "delegates tags to the migration" do
    proxy = TestProxy.new
    proxy.migration = PreDeployMigration.new

    expect(proxy.tags).to eq([:predeploy])
  end
end
