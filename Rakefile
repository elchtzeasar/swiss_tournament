require 'cucumber/rake/task'
require 'rspec/core/rake_task'


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
