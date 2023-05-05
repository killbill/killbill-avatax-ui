# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'avatax/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'killbill-avatax'
  s.version     = Avatax::VERSION
  s.author      = 'Kill Bill core team'
  s.email       = 'killbilling-users@googlegroups.com'
  s.homepage    = 'https://killbill.io'
  s.summary     = 'Kill Bill Avatax UI mountable engine'
  s.description = 'Rails UI plugin for the Avatax plugin.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*'] + %w[MIT-LICENSE Rakefile README.md]
  s.test_files = Dir['test/**/*']

  s.add_dependency 'font-awesome-rails'
  s.add_dependency 'jquery-datatables-rails'
  s.add_dependency 'jquery-rails', '~> 4.5.1'
  s.add_dependency 'killbill-client'
  s.add_dependency 'rails', '~> 7.0'
  s.add_dependency 'sass-rails'

  s.add_development_dependency 'gem-release'
  s.add_development_dependency 'json'
  s.add_development_dependency 'listen'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'simplecov'
end
