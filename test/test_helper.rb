require 'test/unit'
require 'lib/base'
Server.environment = 'test'
require 'lib/xml'
require 'entry'

require Server.root + '/server'

class Test::Unit::TestCase
  def fixture(simple_path)
    dir, name = simple_path.split '/'

    path = File.join(Server.root, 'test', 'fixtures', dir, "#{name}.xml")

    File.read path
  end

  def load_fixture(container, name)
    klass = Kernel.const_get(container.to_s.singularize.classify)
    klass.destroy name.to_s

    filename = name.split('/').last

    content = fixture "#{container}/#{filename}"
    klass.create :name => name, :content => content
  end
end

module ControllerTest

  def controller_name
    @controller_name ||= self.class.to_s.gsub(/Test$/, '')
  end

  def new_controller
    Kernel.const_get(controller_name).new
  end

  def get(path)
    fake_request = FakeRequest.new(path)
    @controller = fake_request.handler.route.controller
    @body = @controller.response.body
  end

  def assert_response(type, message = nil)
    case type
    when :success
      assert_equal 200, @controller.response.status, 
      "Expected response #{type} but got #{@controller.response.status}"
    end
  end

end

class FakeRequest

  attr_accessor :handler, :request, :response

  def initialize(path)
    self.handler = Handler.new

    self.request = OpenStruct.new :params => {'REQUEST_PATH' => path}
    self.response = TestResponse.new

    handler.process request, response
  end
end

class TestOutputter
  attr_accessor :output

  def write(output)
    self.output = output
  end
end

class TestResponse < OpenStruct
  attr_accessor :outputter

  def start(status)
    head = {}
    self.outputter = TestOutputter.new
    yield head, self.outputter
  end
end

