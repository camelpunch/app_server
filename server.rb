#!/usr/bin/env jruby

require 'lib/base'

if $0 == __FILE__
  h = Mongrel::HttpServer.new("0.0.0.0", 3000)
  h.register("/", Handler.new)
  h.register("/public", 
             Mongrel::DirHandler.new(File.join(Server.root, 'public')))
  puts "loaded"
  h.run.join
end
