$:.unshift File.join( File.dirname(__FILE__), "lib")

require 'rspec/core/rake_task'
require 'coveralls/rake/task'
require 'gboard'

RSpec::Core::RakeTask.new(:spec)
Coveralls::RakeTask.new

namespace :gboard do
  task :metrics do
    Gboard::Store.perform
  end
  task :alerts do
    Gboard::Alerts.perform
  end
  task :all do
    Gboard::Store.perform
    Gboard::Alerts.perform
  end
end

task :default => [:spec, "coveralls:push"]
