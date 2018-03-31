require 'simplecov'
SimpleCov.start do
  add_filter 'lib/outrigger/version.rb'
  add_filter 'spec'
  track_files 'lib/**/*.rb'
end
SimpleCov.minimum_coverage(85) # TODO: add better coverage

require 'bundler/setup'
require 'outrigger'

RSpec.configure do |config|
  config.order = 'random'
end
