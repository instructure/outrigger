# frozen_string_literal: true

module Outrigger
  class Railtie < Rails::Railtie
    railtie_name :taggable_migrations

    rake_tasks do
      load "tasks/outrigger.rake"
    end

    initializer "extend_migrations" do
      ActiveSupport.on_load :active_record do
        ActiveRecord::Migration.include(Outrigger::Taggable)
        ActiveRecord::MigrationProxy.include(Outrigger::TaggableProxy)
        ActiveRecord::Migrator.prepend(Outrigger::Migrator)
      end
    end
  end
end
