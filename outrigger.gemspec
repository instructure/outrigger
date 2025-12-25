# frozen_string_literal: true

require_relative 'lib/outrigger/version'

Gem::Specification.new do |s|
  s.name          = 'outrigger'
  s.version       = Outrigger::VERSION
  s.authors       = ['Drew Bowman']
  s.homepage      = 'https://github.com/instructure/outrigger'
  s.summary       = 'Tag migrations and run them separately'
  s.license       = 'MIT'
  s.description   = 'Migrations'

  s.files         = Dir.glob('{lib,spec}/**/*') + %w[Rakefile]
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_paths = ['lib']
  s.metadata['rubygems_mfa_required'] = 'true'

  s.required_ruby_version = '>= 3.2'

  s.add_dependency 'activerecord', '>= 6.0', '< 8.2'
  s.add_dependency 'railties', '>= 6.0', '< 8.2'

  s.add_development_dependency 'bundler', '~> 2.2'
  s.add_development_dependency 'byebug', '~> 11.1'
  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'rspec', '~> 3.7'
  s.add_development_dependency 'rubocop', '~> 1.20'
  s.add_development_dependency 'rubocop-rake', '~> 0.6'
  s.add_development_dependency 'rubocop-rspec', '~> 3.6'
  s.add_development_dependency 'simplecov', '~> 0.21'
end
