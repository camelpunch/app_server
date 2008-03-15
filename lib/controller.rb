require 'ostruct'

class Response < OpenStruct
end

class Controller
  
  attr_accessor :response, :action_name

  def initialize
    self.response = Response.new(:status => 200)
  end

  def render
    controller_name = self.class.to_s.gsub(/Controller$/, '').underscore
    template_filename = "#{action_name}.atomserv.xq"

    template_path = File.join(Server.root, 'app', 'views', controller_name,
                              template_filename)

    Xml.query(File.read(template_path))
  end

end

