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

  s.required_ruby_version = '~> 2.3'

  s.add_dependency 'activerecord', '>= 4.2', '< 5.2'

  s.add_development_dependency 'bundler', '~> 1.15'
  s.add_development_dependency 'rake', '~> 12.0'
  s.add_development_dependency 'rspec', '~> 3.6.0'
  s.add_development_dependency 'rubocop', '~> 0.50.0'
  s.add_development_dependency 'simplecov', '~> 0'
end
