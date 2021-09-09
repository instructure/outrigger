# frozen_string_literal: true

module Outrigger
  describe Migrator do
    around do |example|
      Outrigger.ordered = { predeploy: -1, postdeploy: 1 }
      example.call
    ensure
      Outrigger.ordered = nil
    end

    let(:migrations) do
      [PostDeployMigration.new(nil, 1), UntaggedMigration.new(nil, 2), PreDeployMigration.new(nil, 3),
       MultiMigration.new(nil, 4)]
    end

    before do
      allow(ActiveRecord::InternalMetadata).to receive(:create_table)
    end

    it 'sorts' do
      schema_migration = object_double(ActiveRecord::SchemaMigration, create_table: nil, all_versions: [])
      expect(ActiveRecord::Migrator.new(:up, migrations, schema_migration).runnable.map(&:class)).to eq(
        [
          PreDeployMigration, MultiMigration, UntaggedMigration, PostDeployMigration
        ]
      )
    end

    it 'reverse sorts when going down' do
      schema_migration = object_double(ActiveRecord::SchemaMigration, create_table: nil, all_versions: [1, 2, 3, 4])
      expect(ActiveRecord::Migrator.new(:down, migrations, schema_migration).runnable.map(&:class)).to eq(
        [
          PostDeployMigration, UntaggedMigration, MultiMigration, PreDeployMigration
        ]
      )
    end
  end
end
