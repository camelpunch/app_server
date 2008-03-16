require 'ostruct'

class Response < OpenStruct
end

class Controller
  
  attr_accessor :response, :action_name, :hostname, :path

  def initialize
    self.response = Response.new(:status => 200)
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

    Xml.query query_source, :variables => {
      :path => path,
      :hostname => hostname,
    }
  end

end

