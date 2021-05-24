lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'outrigger/version'

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
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.3.0'

  s.add_dependency 'activerecord', '>= 5.0', '< 6.2'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'railties', '>= 5.0', '< 6.2'
  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'rspec', '~> 3.7'
  s.add_development_dependency 'rubocop', '~> 0.52.0'
  s.add_development_dependency 'simplecov', '~> 0'
  s.add_development_dependency 'wwtd', '~> 1.3'
end
