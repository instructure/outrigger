require 'spec_helper'
require 'rubocop/rspec/support'
require_relative '../../../../lib/outrigger/cops/migration/tagged'

describe RuboCop::Cop::Migration::Tagged do
  context 'with empty AllowedTags' do
    let(:config) do
      RuboCop::Config.new(
        'Migration/Tagged' => {
          'Enabled' => true,
          'AllowedTags' => []
        }
      )
    end

    subject(:cop) { described_class.new(config) }

    it 'allows if not migration' do
      inspect_source(%(
        class Foo
          def bar
            puts 'baz'
          end
        end
      ))
      expect(cop.offenses.size).to eq(0)
    end

    it 'allows if empty migration' do
      inspect_source(%(
        class FooMigration < ActiveRecord::Migration
        end
      ))
      expect(cop.offenses.size).to eq(0)
    end

    it 'disallows if non-empty migration' do
      inspect_source(%(
        class FooMigration < ActiveRecord::Migration
          def up
          end
        end
      ))
      expect(cop.offenses.size).to eq(1)
      expect(cop.messages.first).to match(/No AllowedTags have been defined/)
      expect(cop.offenses.first.severity.name).to eq(:warning)
    end
  end

  context 'with non-empty AllowedTags' do
    let(:config) do
      RuboCop::Config.new(
        'Migration/Tagged' => {
          'Enabled' => true,
          'AllowedTags' => ['predeploy']
        }
      )
    end

    subject(:cop) { described_class.new(config) }

    it 'disallows if non-empty migration' do
      inspect_source(%(
        class FooMigration < ActiveRecord::Migration
          def up
          end
        end
      ))
      expect(cop.offenses.size).to eq(1)
      expect(cop.messages.first).to match(/All migrations require a tag/)
      expect(cop.offenses.first.severity.name).to eq(:warning)
    end

    it 'disallows bad tag' do
      inspect_source(%(
        class FooMigration < ActiveRecord::Migration
          tag :prrreeeedeploy
          def up
          end
        end
      ))
      expect(cop.offenses.size).to eq(1)
      expect(cop.messages.first).to match(/Tags may only be one of \[:predeploy\]. Bad tag: prrreeeedeploy/)
      expect(cop.offenses.first.severity.name).to eq(:warning)
    end

    it 'allows good tag' do
      inspect_source(%(
        class FooMigration < ActiveRecord::Migration
          tag :predeploy
          def up
          end
        end
      ))
      expect(cop.offenses.size).to eq(0)
    end

    context 'with AR version tagged migrations' do
      it 'disallows bad tag' do
        inspect_source(%(
        class FooMigration < ActiveRecord::Migration[5.0]
          tag :prrreeeedeploy
          def up
          end
        end
      ))
        expect(cop.offenses.size).to eq(1)
        expect(cop.messages.first).to match(/Tags may only be one of \[:predeploy\]. Bad tag: prrreeeedeploy/)
        expect(cop.offenses.first.severity.name).to eq(:warning)
      end

      it 'allows good tag' do
        inspect_source(%(
        class FooMigration < ActiveRecord::Migration[5.0]
          tag :predeploy
          def up
          end
        end
      ))
        expect(cop.offenses.size).to eq(0)
      end
    end
  end
end
