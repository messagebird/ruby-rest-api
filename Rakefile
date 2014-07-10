require 'rake/testtask'

namespace :gem do
  desc 'Build the messagebird API gem'
  task :build do
    sh 'gem build messagebird-rest.gemspec'
  end

  desc 'Upload the gem to rubygems.org'
  task :upload do
    sh 'gem push messagebird-rest-*.gem'
  end
end
