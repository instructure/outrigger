require 'spec_helper'

describe Outrigger do
  describe 'filter' do
    it 'should return a proc that tests migrations' do
      filter = Outrigger.filter(:predeploy)

      expect(filter.call(PreDeployMigration)).to eq(true)
    end

    it 'should accept multiple tags' do
      filter = Outrigger.filter(:predeploy, :postdeploy)

      expect(filter.call(MultiMigration)).to eq(true)
      expect(filter.call(PreDeployMigration)).to eq(false)
    end
  end
end
