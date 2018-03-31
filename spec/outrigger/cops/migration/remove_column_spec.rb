require 'spec_helper'
require 'rubocop/rspec/support'
require_relative '../../../../lib/outrigger/cops/migration/remove_column'

describe RuboCop::Cop::Migration::RemoveColumn do
  context 'with nil BannedTags' do
    let(:config) do
      RuboCop::Config.new(
        'Migration/RemoveColumn' => {
          'Enabled' => true
        }
      )
    end

    subject(:cop) { described_class.new(config) }

    context 'predeploy' do
      it 'complains about empty banned tags' do
        inspect_source(%(
        class MyMigration < ActiveRecord::Migration
          def up
            remove_column :x, :y
          end
        end
      ))
        expect(cop.offenses.size).to eq(1)
        expect(cop.messages.first).to match(/No BannedTags have been defined in the RuboCop configuration/)
        expect(cop.offenses.first.severity.name).to eq(:warning)
      end
    end
  end

  context 'with non empty BannedTags' do
    let(:config) do
      RuboCop::Config.new(
        'Migration/RemoveColumn' => {
          'Enabled' => true,
          'BannedTags' => ['predeploy']
        }
      )
    end

    subject(:cop) { described_class.new(config) }

    context 'single banned tag' do
      it 'disallows remove_column in `up`' do
        inspect_source(%(
          class MyMigration < ActiveRecord::Migration[5.0]
            tag :predeploy
            def up
              remove_column :x, :y
            end
          end
        ))
        expect(cop.offenses.size).to eq(1)
        expect(cop.messages.first).to match(/remove_column/)
        expect(cop.offenses.first.severity.name).to eq(:warning)
      end

      it 'disallows remove_column in `self.up`' do
        inspect_source(%(
          class MyMigration < ActiveRecord::Migration
            tag :predeploy
            def self.up
              remove_column :x, :y
            end
          end
        ))
        expect(cop.offenses.size).to eq(1)
        expect(cop.messages.first).to match(/remove_column/)
        expect(cop.offenses.first.severity.name).to eq(:warning)
      end

      it 'allows remove_column in `down`' do
        inspect_source(%(
          class MyMigration < ActiveRecord::Migration
            tag :predeploy
            def down
              remove_column :x, :y
            end
          end
        ))
        expect(cop.offenses.size).to eq(0)
      end

      it 'allows remove_column in a non migration class `up`' do
        inspect_source(%{
          class MyMigration < ActiveRecord::Migration
            tag :predeploy
            def down
              remove_column :x, :y
            end
          end
          class Foobar < ActiveRecord::Base
            # why you would do this, i know not
            def up
              remove_column :x, :y
            end
            private
            def remove_column(x, y)
              puts x
              puts y
            end
          end
        })
        expect(cop.offenses.size).to eq(0)
      end
    end

    context 'single allowed tag' do
      it 'allows remove_column in `up`' do
        inspect_source(%(
          class MyMigration < ActiveRecord::Migration
            tag :postdeploy
            def up
              remove_column :x, :y
            end
          end
        ))
        expect(cop.offenses.size).to eq(0)
      end

      context 'with AR version tagged migrations' do
        it 'allows remove_column in `up`' do
          inspect_source(%(
          class MyMigration < ActiveRecord::Migration[5.0]
            tag :postdeploy
            def up
              remove_column :x, :y
            end
          end
        ))
          expect(cop.offenses.size).to eq(0)
        end
      end
    end

    context 'multiple tags including a banned tag' do
      it 'disallows remove_column in `up`' do
        inspect_source(%(
          class MyMigration < ActiveRecord::Migration
            tag [:predeploy, :dynamo]
            def up
              remove_column :x, :y
            end
          end
        ))
        expect(cop.offenses.size).to eq(1)
        expect(cop.messages.first).to match(/remove_column/)
        expect(cop.offenses.first.severity.name).to eq(:warning)
      end

      context 'with AR version tagged migrations' do
        it 'disallows remove_column in `up`' do
          inspect_source(%(
          class MyMigration < ActiveRecord::Migration[5.0]
            tag [:predeploy, :dynamo]
            def up
              remove_column :x, :y
            end
          end
        ))
          expect(cop.offenses.size).to eq(1)
          expect(cop.messages.first).to match(/remove_column/)
          expect(cop.offenses.first.severity.name).to eq(:warning)
        end
      end
    end

    context 'multiple tags not including a banned tag' do
      it 'allows remove_column in `up`' do
        inspect_source(%(
          class MyMigration < ActiveRecord::Migration
            tag [:postdeploy, :dynamo]
            def up
              remove_column :x, :y
            end
          end
        ))
        expect(cop.offenses.size).to eq(0)
      end

      context 'with AR version tagged migrations' do
        it 'allows remove_column in `up`' do
          inspect_source(%(
          class MyMigration < ActiveRecord::Migration[5.0]
            tag [:postdeploy, :dynamo]
            def up
              remove_column :x, :y
            end
          end
        ))
          expect(cop.offenses.size).to eq(0)
        end
      end
    end
  end
end
