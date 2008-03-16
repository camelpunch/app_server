require 'lib/base'
Server.environment = 'development'
require 'lib/xml' # must be after env is set!
require 'mongrel'
require 'md5'
require 'app/controllers/collections_controller'
require 'app/controllers/entries_controller'

# instantiates a controller given a request object
class Route
  attr_accessor :controller

  def initialize(path)
    if path == '/collections'
      self.controller = CollectionsController.new
      controller.action_name = 'index'
    elsif path.count('/') == 1
      self.controller = EntriesController.new
      controller.action_name = 'index'
    else
      puts path
      puts path.count('/')
    end
    controller.path = path
    controller.response.body = controller.send controller.action_name
  end

end

class Handler < Mongrel::HttpHandler
  attr_accessor :route

  def process(request, response)
    self.route = Route.new request.params['REQUEST_PATH']

    response.start(self.route.controller.response.status) do |head, out|
      # puts request.params.inspect

      body = <<XML
<?xml version="1.0" encoding="utf-8"?>
#{self.route.controller.response.body}
XML
      head["Content-Type"] = "application/atomserv+xml"
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
