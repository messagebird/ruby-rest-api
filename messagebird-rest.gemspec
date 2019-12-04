# -*- encoding: utf-8 -*-
# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("lib", __dir__)

require "messagebird/version"

Gem::Specification.new do |s|
  s.name        = "messagebird-rest"
  s.version     = MessageBird::Version::STRING
  s.platform    = Gem::Platform::RUBY
  s.required_ruby_version = ">= 1.9.3"
  s.date        = Time.now
  s.summary     = "MessageBird's REST API"
  s.description = "A simple REST API for MessageBird in Ruby"
  s.author      = "Maurice Nonnekes"
  s.email       = "maurice@messagebird.com"
  s.files       = `git ls-files lib LICENSE README.md`
                  .split($RS)
  s.homepage    = "https://github.com/messagebird/ruby-rest-api"
  s.license     = "BSD-2-Clause"

  s.files        = Dir.glob("lib/**/*") + %w(LICENSE README.md)
  s.require_path = "lib"
end
