require 'cucumber/rake/task'
require 'rspec/core/rake_task'

require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "swiss_tournament"
  gem.homepage = "http://github.com/elchtzeasar/swiss_tournament"
  gem.license = "MIT"
  gem.summary = %Q{Swiss tournament plugin for a Rails application}
  gem.description = %Q{Plugin to be used in a rails application that manages swiss tournaments.}
  gem.email = "westman.peter@gmail.com"
  gem.authors = ["Peter Westman"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

namespace 'test' do
  desc 'Run unit tests'
  RSpec::Core::RakeTask.new(:unit)
  
  namespace 'system' do
    Cucumber::Rake::Task.new(:verified, 'Run non-wip system tests') do |task|
      task.cucumber_opts = %w{--tags ~@wip features}
    end

    Cucumber::Rake::Task.new(:wip, 'Run wip system tests') do |task|
      task.cucumber_opts = %w{--tags @wip features}
    end
  end
  
  desc 'Run system tests'
  task :system => 'test:system:verified' do
  end
end

desc 'Run unit, component and system tests'
  task :test => ['test:unit', 'test:system'] do
end
