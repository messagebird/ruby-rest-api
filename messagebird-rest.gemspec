# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'messagebird/version'

Gem::Specification.new do |s|
  s.name        = 'messagebird-rest'
  s.version     = MessageBird::Version::STRING
  s.platform    = Gem::Platform::RUBY
  s.required_ruby_version = '>= 3.0'
  s.date        = Time.now
  s.summary     = "MessageBird's REST API"
  s.description = 'A simple REST API for MessageBird in Ruby'
  s.author      = 'Maurice Nonnekes'
  s.email       = 'maurice@messagebird.com'
  s.files       = `git ls-files lib LICENSE README.md`
                  .split($RS)
  s.homepage    = 'https://github.com/messagebird/ruby-rest-api'
  s.license     = 'BSD-2-Clause'

  s.files        = Dir.glob('lib/**/*') + %w(LICENSE README.md)
  s.require_path = 'lib'

  s.add_dependency "jwt",  "~> 2.3"

  s.add_development_dependency "rspec", "~> 3.11.0"
  s.add_development_dependency "rubocop", "~> 1.26.1"
  s.add_development_dependency 'webmock', '~> 3.14.0'
end
