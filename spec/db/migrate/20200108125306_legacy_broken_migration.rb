# frozen_string_literal: true

class LegacyBrokenMigration < ActiveRecord::Migration[5.0]
  tag :broken

  BreakableChange.run

  def change
    UnresolvedModel.run
  end
end
