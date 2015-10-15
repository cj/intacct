# coding: utf-8
$:.push File.expand_path("../lib", __FILE__)
# require 'intacct/version'

Gem::Specification.new do |spec|
  spec.name          = %q{intacct}
  spec.version       = '0.0.3'
  spec.authors       = ['Mavenlink, Inc.', 'Adam Bedford', 'CJ Lazell']
  spec.email         = %q{opensource@mavenlink.com}
  spec.description   = %q{Ruby wrapper for the Intacct Web Services API}
  spec.summary       = %q{Ruby Intacct API Client}
  spec.homepage      = %q{http://github.com/mavenlink-solutions/intacct-ruby}

  spec.files         = `git ls-files`.split('\n')
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'nokogiri'
  spec.add_dependency 'hooks'

  spec.add_runtime_dependency 'activesupport'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'turnip'
  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'dotenv-rails'
  spec.add_development_dependency 'faker', '>=1.2.0'
end
