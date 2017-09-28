require 'spec_helper'

module ActiveRecord
  class Migration
    include Outrigger::Taggable
  end
end

describe Outrigger::Taggable do
  before do
    class PreDeployMigration < ActiveRecord::Migration
      tag :predeploy
    end

    class UntaggedMigration < ActiveRecord::Migration
    end

    class PostDeployMigration < ActiveRecord::Migration
      tag :postdeploy
    end
  end

  it 'PreDeployMigration should be predeploy' do
    expect(PreDeployMigration.tags).to eq([:predeploy])
  end

  it 'UntaggedMigration should be have no tags' do
    expect(UntaggedMigration.tags).to eq([])
  end

  it 'PostDeployMigration should be predeploy' do
    expect(PostDeployMigration.tags).to eq([:postdeploy])
  end

  it 'instance tags should point to class tags' do
    expect(PreDeployMigration.new.tags).to eq([:predeploy])
  end
end
