# frozen_string_literal: true

require 'simplecov'
SimpleCov.start do
  add_filter 'lib/outrigger/version.rb'
  add_filter 'spec'
  track_files 'lib/**/*.rb'
end
SimpleCov.minimum_coverage(85)

require 'bundler/setup'
require 'rails/railtie'
require 'rubocop'
require 'rubocop/rspec/support'

require 'outrigger'

ActiveRecord::Migration.include(Outrigger::Taggable)
ActiveRecord::MigrationProxy.include(Outrigger::TaggableProxy)

class PreDeployMigration < ActiveRecord::Migration[5.0]
  tag :predeploy
end

class UntaggedMigration < ActiveRecord::Migration[5.0]
end

class PostDeployMigration < ActiveRecord::Migration[5.0]
  tag :postdeploy
end

class MultiMigration < ActiveRecord::Migration[5.0]
  tag :predeploy, :postdeploy
end

RSpec.configure do |config|
  config.order = 'random'
end
