require 'rubygems'
require 'active_support'
require 'mongrel'
require 'md5'

module Server
  mattr_accessor :environment

  self.environment = 'development' # refactor to use command line options
  
  def self.root
    File.join File.dirname(__FILE__), '..'
  end
end

$: << File.join(Server.root, 'app', 'models')

require 'lib/xml' # must be after env is set!
require 'lib/controller'
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

      if path =~ /\/.*\/.*/
        controller.action_name = :show
      else
        case method
        when 'GET'
          controller.action_name = :index
        when 'POST'
          controller.action_name = :create
        end
      end
    end
  end

  # call the action and store the return value in response.body
  def process!
    if Server.environment == 'development'
      puts "----------request--------------\n#{controller.request.inspect}"
      puts controller.request.body.read
      controller.request.body.rewind
    end

    controller.response.body = controller.send(controller.action_name)

    if Server.environment == 'development'
      puts "----------response--------------\n#{controller.response.inspect}"
    end
  end

end

class Handler < Mongrel::HttpHandler
  attr_accessor :route

  def process(request, response)
    self.route = Route.new request
    route.process!

    controller = route.controller

    response.start controller.response.status do |head, out|
      #puts controller.response.status
      #puts request.params.inspect

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


