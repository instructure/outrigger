namespace :db do
  namespace :migrate do
    desc 'Run migrations for a Tag'
    task tagged: %i[environment load_config] do |_t, args|
      puts("Migrating Tags: #{args.extras}")
      if ActiveRecord.gem_version >= Gem::Version.new('5.2.0')
        ActiveRecord::Base.connection.migration_context.migrate(nil, &Outrigger.filter(args.extras))
      else
        ActiveRecord::Migrator.migrate(ActiveRecord::Migrator.migrations_paths, &Outrigger.filter(args.extras))
      end
    end
  end
end
