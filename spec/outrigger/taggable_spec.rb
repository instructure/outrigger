# frozen_string_literal: true

describe Outrigger::Taggable do
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
