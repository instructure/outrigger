require 'bundler/gem_tasks'

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)

  task(default: :spec)
rescue LoadError # rubocop:disable Lint/HandleExceptions
  # no rspec available
end

task :console do
  require 'irb'
  require 'irb/completion'
  require 'outrigger'
  ARGV.clear
  IRB.start
end
