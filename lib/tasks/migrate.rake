namespace :db do
  namespace :migrate do
    desc 'Run migrations for a Tag'
    task tagged: %i[environment load_config] do |_t, args|
      puts("Migrating Tags: #{args.extras}")
      ActiveRecord::Migrator.migrate(ActiveRecord::Migrator.migrations_paths, &Outrigger.filter(args.extras))
    end
  end
end
