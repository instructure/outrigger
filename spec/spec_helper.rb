require 'simplecov'
SimpleCov.start do
  add_filter 'lib/outrigger/version.rb'
  add_filter 'spec'
  track_files 'lib/**/*.rb'
end
SimpleCov.minimum_coverage(75)

require 'bundler/setup'
require 'rails/railtie'
require 'rubocop'
require 'rubocop/rspec/support'

require 'outrigger'

RSpec.configure do |config|
  config.order = 'random'
end
