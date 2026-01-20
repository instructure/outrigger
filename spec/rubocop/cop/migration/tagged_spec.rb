# frozen_string_literal: true

require "outrigger/cops/migration/tagged"

RSpec.describe RuboCop::Cop::Migration::Tagged do
  let(:config_hash) do
    {
      "Migration/Tagged" => {
        "AllowedTags" => %w[predeploy deploy],
        "Enabled" => true
      }
    }
  end

  let(:config) { RuboCop::Config.new(config_hash) }

  let(:migration_class) do
    <<~RUBY
      class Test < ActiveRecord::Migration[4.2]
        tag :predeploy
        def change
        end
      end
    RUBY
  end

  subject(:cop) { described_class.new(config) } # rubocop:disable RSpec/LeadingSubject

  shared_examples_for "valid migrations" do
    it "passes valid versioned migration" do
      inspect_source(migration_class)
      expect(cop.offenses.empty?).to be(true)
    end
  end

  context "with valid config" do
    it_behaves_like "valid migrations"

    context "with missing tags" do
      let(:migration_class) do
        <<~RUBY
          class Test < ActiveRecord::Migration[4.2]
            def change
            end
          end
        RUBY
      end

      it "finds missing tag in versioned migration" do
        inspect_source(migration_class)
        expect(cop.offenses.empty?).to be(false)
        expect(cop.offenses.first.message).to match(/All migrations require a tag from/)
      end
    end

    context "with invalid tag" do
      let(:migration_class) do
        <<~RUBY
          class Test < ActiveRecord::Migration[4.2]
            tag :foobar
            def change
            end
          end
        RUBY
      end

      it "fails on invalid tag in versioned migration" do
        inspect_source(migration_class)
        expect(cop.offenses.empty?).to be(false)
        expect(cop.offenses.first.message).to match(/Tags may only be one of/)
      end
    end
  end

  context "with invalid config" do
    let(:config_hash) do
      {
        "Migration/Tagged" => {
          "AllowedTags" => [],
          "Enabled" => true
        }
      }
    end

    it "fails on missing tags in configuration on versioned migration" do
      inspect_source(migration_class)
      expect(cop.offenses.empty?).to be(false)
      expect(cop.offenses.first.message).to match(/No allowed tags have been defined/)
    end
  end
end
