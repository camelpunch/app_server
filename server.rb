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

  attr_accessor :controller

  def initialize(request)
    path = request.params['REQUEST_PATH']
    method = request.params['REQUEST_METHOD']

    if path == '/collections'
      self.controller = CollectionsController.new request
      controller.action_name = 'index'

    elsif path.count('/') == 1
      self.controller = EntriesController.new request

      case method
      when 'GET'
        controller.action_name = 'index'
      when 'POST'
        controller.action_name = 'create'
      else
        raise UnrecognisedHTTPMethod, "Unrecognised method: #{method}"
      end
    else
      puts path
      puts path.count('/')
    end

    controller.response.body = controller.send controller.action_name
  end

end

class Handler < Mongrel::HttpHandler
  attr_accessor :route

  def process(request, response)
    self.route = Route.new request

    controller = route.controller

    response.start controller.response.status do |head, out|
      puts controller.response.status
      puts request.params.inspect

      body = controller.response.body

      controller.response.headers.each do |name, value|
        head[name] = value
      end
      head["ETag"] = MD5.new body

      if request.params['HTTP_ACCEPT_ENCODING'] == 'gzip,deflate'
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
  puts "loaded"
  h.run.join
end
