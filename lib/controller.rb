require 'ostruct'

class Response < OpenStruct
end

class Controller
  
  attr_accessor :request, :response, :action_name, :hostname, :path

  def initialize(request)
    self.request = request
    self.response = Response.new :status => 200, :headers => {}
  end

  def hostname
    request.params['HTTP_HOST']
  end

  def path
    request.params['REQUEST_PATH']
  end

  def template_path(content_type)
    controller_name = self.class.to_s.gsub(/Controller$/, '').underscore
    template_filename = "#{action_name}.#{content_type}.xq"

    File.join(Server.root, 'app', 'views', controller_name, template_filename)
  end

  def render
    begin
      query_source = File.read template_path(:atomserv)
    rescue Errno::ENOENT
      query_source = File.read template_path(:atom)
    end

    query_result = Xml.query query_source, :variables => {
      :path => path,
      :hostname => hostname,
    }

    return <<XML
<?xml version="1.0" encoding="utf-8"?>
#{query_result}
XML
  end

end

