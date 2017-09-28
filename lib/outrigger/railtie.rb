require 'rails'
require 'rake'

module Outrigger
  class Railtie < Rails::Railtie
    railtie_name :taggable_migrations

    rake_tasks do
      load 'tasks/migrate.rake'
    end

    initializer 'extend_migrations' do
      ActiveSupport.on_load :active_record do
        ActiveRecord::Migration.send :include, Outrigger::Taggable
        ActiveRecord::MigrationProxy.send :include, Outrigger::TaggableProxy
      end
    end
  end
end
