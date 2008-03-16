require 'test/unit'
require 'lib/base'
Server.environment = 'test'
require 'lib/xml'

require 'collection'
require 'entry'

require Server.root + '/server'

CompactSchemaReader = com.thaiopensource.validate.rng.CompactSchemaReader
ValidationDriver = com.thaiopensource.validate.ValidationDriver
StringReader = java.io.StringReader
StringWriter = java.io.StringWriter
InputSource = org.xml.sax.InputSource
ErrorHandlerImpl = com.thaiopensource.xml.sax.ErrorHandlerImpl
PropertyMapBuilder = com.thaiopensource.util.PropertyMapBuilder
ValidateProperty = com.thaiopensource.validate.ValidateProperty

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

  # adapted from
  # https://ape.dev.java.net/source/browse/ape/src/validator.rb?rev=1.2&view=markup
  def assert_valid(schema_type, text)
    case schema_type
    when :app
      schema = File.read '/home/andrew/dev/app_server/lib/app.rnc'
    end

    schema_error = StringWriter.new
    error_handler = ErrorHandlerImpl.new(schema_error)
    properties = PropertyMapBuilder.new
    properties.put ValidateProperty::ERROR_HANDLER, error_handler
    error = nil
    driver = ValidationDriver.new(properties.to_property_map,
                                  CompactSchemaReader.get_instance)

    if driver.load_schema(InputSource.new(StringReader.new(schema)))
      assert driver.validate(InputSource.new(StringReader.new(text))),
        schema_error.to_string
    else
      raise RuntimeError, "couldn't load schema"
    end
  end
end

module ControllerTest

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

  def assert_include(text)
    assert @body.include?(text), "Expected #{text} to be in:\n #{@body}"
  end

  def assert_not_include(text)
    assert ! @body.include?(text), "Expected #{text} to not be in:\n #{@body}"
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

