# -*- encoding: utf-8 -*-
# frozen_string_literal: true

libdir = File.expand_path("../lib/", __FILE__)
$:.unshift(libdir) unless $:.include?(libdir)
require "messagebird"

Gem::Specification.new do |s|
  s.name        = "messagebird-rest"
  s.version     = MessageBird::CLIENT_VERSION
  s.platform    = Gem::Platform::RUBY
  s.date        = Time.now
  s.summary     = "MessageBird's REST API"
  s.description = "A simple REST API for MessageBird in Ruby"
  s.author      = "Maurice Nonnekes"
  s.email       = "maurice@messagebird.com"
  s.homepage    = "https://github.com/messagebird/ruby-rest-api"
  s.license     = "BSD-2-Clause"

  s.files        = Dir.glob("lib/**/*") + %w(LICENSE README.md)
  s.require_path = "lib"

  s.add_development_dependency "rspec", "~> 3.8"
end
