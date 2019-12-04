# frozen_string_literal: true

require "rake/testtask"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = Dir.glob("spec/**/*_spec.rb")
end

namespace :gem do
  desc "Build the messagebird API gem"
  task :build do
    sh "gem build messagebird-rest.gemspec"
  end

  desc "Upload the gem to rubygems.org"
  task :upload do
    sh "gem push messagebird-rest-*.gem"
  end
end
