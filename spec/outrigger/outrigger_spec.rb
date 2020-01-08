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

    it 'should handle broken migrations' do
      filter = Outrigger.filter(:broken)

      ActiveRecord::Migration.send :include, Outrigger::Taggable
      ActiveRecord::MigrationProxy.send :include, Outrigger::TaggableProxy
      legacy_migration = ActiveRecord::MigrationProxy.new(
        'LegacyBrokenMigration',
        '20200108125306',
        'spec/db/migrate/20200108125306_legacy_broken_migration.rb',
        nil
      )

      expect(filter.call(legacy_migration)).to eq(false)
    end
  end
end
