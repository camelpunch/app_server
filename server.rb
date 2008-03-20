#!/usr/bin/env jruby

require 'lib/base'
Server.environment = 'development'
require 'lib/xml' # must be after env is set!
require 'mongrel'
require 'md5'
require 'app/controllers/collections_controller'
require 'app/controllers/entries_controller'

# instantiates a controller given a request object
class Route
  class UnrecognisedHTTPMethod < RuntimeError; end
  class UnrecognisedPath < RuntimeError; end

  attr_accessor :controller, :args

  def initialize(request)
    self.args = []

    path = request.params['REQUEST_PATH']
    method = request.params['REQUEST_METHOD']

    if path == '/collections' && method == 'GET'

      self.controller = CollectionsController.new request
      controller.action_name = :index

    else

      self.controller = EntriesController.new request

      if path =~ /\/.*\/(.*)/
        controller.action_name = :show
        return true
      else
        Collection.names.each do |name|
          if path == "/#{name}"
            case method
            when 'GET'
              controller.action_name = :index
              return true
            when 'POST'
              controller.action_name = :create
              return true
            end
          end
        end
      end

    end
  end

  # call the action and store the return value in response.body
  def process!
    controller.response.body = controller.send(controller.action_name)
  end

end

class Handler < Mongrel::HttpHandler
  attr_accessor :route

  def process(request, response)
    self.route = Route.new request

    controller = route.controller

    response.start controller.response.status do |head, out|
      #puts controller.response.status
      #puts request.params.inspect
      route.process!

      body = controller.response.body

      controller.response.headers.each do |name, value|
        head[name] = value
      end
      head["ETag"] = MD5.new body

      accepted_encoding = request.params['HTTP_ACCEPT_ENCODING']

      if accepted_encoding && accepted_encoding.include?('gzip')
        head["Content-Encoding"] = "deflate"
        out.write Zlib::Deflate.deflate(body)
      else
        out.write body
      end
    end
  end
end

if $0 == __FILE__
  h = Mongrel::HttpServer.new("0.0.0.0", 3000)
  h.register("/", Handler.new)
  h.register("/public", 
             Mongrel::DirHandler.new(File.join(Server.root, 'public')))
  puts "loaded"
  h.run.join
end
