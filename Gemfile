# frozen_string_literal: true

source "https://rubygems.org"

plugin "bundler-multilock", "1.4.0"
return unless Plugin.installed?("bundler-multilock")

Plugin.send(:load_plugin, "bundler-multilock")

gemspec

# rubocop:disable Bundler/DuplicatedGem
lockfile "activerecord-7.1" do
  gem "activerecord", "~> 7.1.0"
  gem "railties", "~> 7.1.0"
end

lockfile "activerecord-7.2" do
  gem "activerecord", "~> 7.2.0"
  gem "rack", "~> 3.1.16"
  gem "railties", "~> 7.2.0"
end

lockfile "activerecord-8.0" do
  gem "activerecord", "~> 8.0.0"
  gem "rack", "~> 3.2"
  gem "railties", "~> 8.0.0"
end

lockfile do
  gem "activerecord", "~> 8.1.0"
  gem "rack", "~> 3.2"
  gem "railties", "~> 8.1.0"
end
# rubocop:enable Bundler/DuplicatedGem

gem "debug", "~> 1.11"
gem "rake", "~> 13.0"
gem "rspec", "~> 3.7"
gem "rubocop-inst", "~> 1.2"
gem "rubocop-rake", "~> 0.6"
gem "rubocop-rspec", "~> 3.6"
gem "simplecov", "~> 0.21"
