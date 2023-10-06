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

    let(:versions) { [] }
    let(:direction) { :up }
    let(:schema_migration) do
      if ActiveRecord.version < Gem::Version.new('7.1')
        object_double(ActiveRecord::SchemaMigration, create_table: nil, all_versions: versions)
      else
        instance_double(ActiveRecord::SchemaMigration, create_table: nil, integer_versions: versions)
      end
    end

    let(:migrator) do
      if ActiveRecord.version < Gem::Version.new('7.1')
        ActiveRecord::Migrator.new(direction, migrations, schema_migration)
      else
        internal_metadata = instance_double(ActiveRecord::InternalMetadata, create_table: nil)
        ActiveRecord::Migrator.new(direction, migrations, schema_migration, internal_metadata)
      end
    end

    before do
      allow(ActiveRecord::InternalMetadata).to receive(:create_table)
    end

    it 'sorts' do
      expect(migrator.runnable.map(&:class)).to eq(
        [
          PreDeployMigration, MultiMigration, UntaggedMigration, PostDeployMigration
        ]
      )
    end

    context 'when going down' do
      let(:versions) { [1, 2, 3, 4] }
      let(:direction) { :down }

      it 'reverse sorts' do
        expect(migrator.runnable.map(&:class)).to eq(
          [
            PostDeployMigration, UntaggedMigration, MultiMigration, PreDeployMigration
          ]
        )
      end
    end
  end
end
