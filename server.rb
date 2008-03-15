require 'lib/base'
Server.environment = 'development'
require 'mongrel'
require 'md5'
require 'app/controllers/introspection_controller'

class Handler < Mongrel::HttpHandler
  def process(request, response)
    response.start(200) do |head,out|

      content = case request.params['REQUEST_PATH']
      when '/introspection'
        controller = IntrospectionController.new
        controller.action_name = 'show'
        controller.show
      end

      body = <<XML
<?xml version="1.0" encoding="utf-8"?>
#{content}
XML
      head["Content-Type"] = "application/atomserv+xml"
      head["ETag"] = MD5.new body
      head["Content-Encoding"] = "deflate"

      out.write Zlib::Deflate.deflate(body)
    end
  end
end

h = Mongrel::HttpServer.new("0.0.0.0", 3000)
h.register("/", Handler.new)
puts "loaded"
h.run.join
