# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'bunnyhop/version'

Gem::Specification.new do |gem|
  gem.authors       = ['FoodRunner']
  gem.email         = ['code@foodrunner.io']
  gem.homepage      = 'https://github.com/foodrunner'
  gem.summary       = 'A thin wrapper around RabbitMQ\'s bunny library'
  gem.description   = 'A thin wrapper around RabbitMQ\'s bunny library'

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.name          = 'bunnyhop'
  gem.require_paths = ['lib']
  gem.version       = BunnyHop::VERSION

  gem.license       = 'MIT'

  gem.add_development_dependency 'rspec', '~> 2.14'

  gem.add_runtime_dependency 'bunny', '~> 1.3.1'
  gem.add_runtime_dependency 'eventmachine', '~> 1.0.3'
  gem.add_runtime_dependency 'amqp', '~> 1.4.1'
  gem.add_runtime_dependency 'oj', '~> 2.5'
  gem.add_runtime_dependency 'activesupport', '>= 3.0.0'
end
