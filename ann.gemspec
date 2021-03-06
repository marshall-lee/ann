# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ann/version'

Gem::Specification.new do |spec|
  spec.name          = 'ann'
  spec.version       = Ann::VERSION
  spec.authors       = ['Vladimir Kochnev']
  spec.email         = ['hashtable@yandex.ru']

  spec.summary       = 'Nothing special, just method annotations done right!'
  spec.homepage      = 'https://github.com/marshall-lee/ann'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.start_with? 'spec/' }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry', '~> 0.10'
end
