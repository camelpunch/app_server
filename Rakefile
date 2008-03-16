require 'rake'
require 'rake/testtask'

task :default => [:tests]

desc "Run all tests"
Rake::TestTask.new("tests") do |t|
  t.pattern = "test/*_test.rb"
end
