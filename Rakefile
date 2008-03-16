require 'rake'
require 'rake/testtask'
require 'lib/base'
Server.environment = 'development'

task :default => :tests

Rake::TestTask.new("tests") do |t|
  t.pattern = "test/*_test.rb"
end

task :clear_database do
  FileUtils.rm_rf("db/development")
  Dir.mkdir("db/development")
  load 'app/models/collection.rb'
  load 'app/models/entry.rb'
end

def load_container(name)
  Dir.glob("test/fixtures/#{name}/*.xml") do |filename|
    doc_name = File.basename(filename).gsub(/\.xml$/, '')
    Kernel.const_get(name.to_s.singularize.classify).
      create(:name => doc_name,
             :content => File.read(filename))
  end
end

desc "Load XML from fixtures"
task :load => :clear_database do
  load_container :collections
  load_container :entries  
end
