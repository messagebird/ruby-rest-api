# encoding: utf-8
# frozen_string_literal: true

source "https://rubygems.org"

group :test, :development do
  if RUBY_VERSION == "1.9.3"
    gem "rspec-expectations", "3.8.2", require: false
  end

  gem "rspec"

  if Gem::Version.new(RUBY_VERSION) < Gem::Version.new("2.3.0")
    gem "rubucop", "~> 0.40.0", require: false
  else
    gem "rubocop", "~> 0.77.0", require: false
  end
end
