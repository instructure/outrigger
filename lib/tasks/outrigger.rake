# frozen_string_literal: true

namespace :db do
  namespace :migrate do
    desc 'Run migrations for a Tag'
    task tagged: %i[environment load_config] do |_t, args|
      puts("Migrating Tags: #{args.extras}")

      Outrigger.migration_context.migrate(nil, &Outrigger.filter(args.extras))
    end
  end
end
