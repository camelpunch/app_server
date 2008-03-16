require 'rake'
require 'rake/testtask'
require 'lib/base'
Server.environment = 'development'

task :default => :tests

Rake::TestTask.new("tests") do |t|
  t.pattern = "test/*_test.rb"
end

desc "Load XML from fixtures"
task :load do
  FileUtils.rm_rf("db/development")
  Dir.mkdir("db/development")
  load 'app/models/collection.rb'
  load 'app/models/entry.rb'

  Dir.glob("test/fixtures/collections/*.xml") do |filename|
    collection_name = File.basename(filename).gsub(/\.xml$/, '')
    Collection.create(:name => collection_name,
                      :content => File.read(filename))
  end

  Dir.glob("test/fixtures/entries/*.xml") do |filename|
    entry_name = File.basename(filename).gsub(/\.xml$/, '')
    Entry.create(:name => entry_name,
                 :content => File.read(filename))
  end
end
