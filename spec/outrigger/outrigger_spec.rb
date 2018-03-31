require 'spec_helper'

describe Outrigger do
  describe 'filter' do
    before do
      class PreDeployMigration < ActiveRecord::Migration[4.2]
        tag :predeploy
      end

      class UntaggedMigration < ActiveRecord::Migration[4.2]
      end

      class MultiMigration < ActiveRecord::Migration[4.2]
        tag :predeploy, :dynamo
      end
    end

    it 'should return a proc that tests migrations' do
      filter = Outrigger.filter(:predeploy)

      expect(filter.call(PreDeployMigration)).to eq(true)
    end

    it 'should accept multiple tags' do
      filter = Outrigger.filter(:predeploy, :dynamo)

      expect(filter.call(MultiMigration)).to eq(true)
      expect(filter.call(PreDeployMigration)).to eq(false)
    end
  end
end
