require 'test/unit'
require 'lib/base'
Server.environment = 'test'
require 'lib/xml'

require 'collection'
require 'entry'

require Server.root + '/server'

include_class com.thaiopensource.validate.rng.CompactSchemaReader
include_class com.thaiopensource.validate.ValidationDriver
include_class java.io.StringReader
include_class java.io.StringWriter
include_class org.xml.sax.InputSource
include_class com.thaiopensource.xml.sax.ErrorHandlerImpl
include_class com.thaiopensource.util.PropertyMapBuilder
include_class com.thaiopensource.validate.ValidateProperty

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
    schema = File.read File.join(Server.root, 'schema', "#{schema_type}.rnc")

    schema_error = StringWriter.new
    error_handler = ErrorHandlerImpl.new(schema_error)
    properties = PropertyMapBuilder.new
    properties.put ValidateProperty::ERROR_HANDLER, error_handler
    error = nil
    driver = ValidationDriver.new(properties.to_property_map,
                                  CompactSchemaReader.get_instance)

    if driver.load_schema(InputSource.new(StringReader.new(schema)))
      assert driver.validate(InputSource.new(StringReader.new(text))),
        "#{schema_error.to_string}\n\n#{text}"
    else
      raise RuntimeError, "couldn't load schema"
    end
  end
end

module ControllerTest

  def get(path)
    fake_request = FakeRequest.new path, :method => :get
    process_request fake_request
  end

  def post(path, options = {})
    options.merge! :method => :post
    fake_request = FakeRequest.new path, options
    process_request fake_request
  end

  def process_request(fake_request)
    @controller = fake_request.handler.route.controller
    @body = @controller.response.body
    @headers = @controller.response.headers
  end

  def assert_response(code)
    assert_equal code, @controller.response.status
  end

  def assert_include(text)
    assert @body.include?(text), "Expected #{text} to be in:\n #{@body}"
  end

  def assert_not_include(text)
    assert ! @body.include?(text), "Expected #{text} to not be in:\n #{@body}"
  end

end

class FakeRequest
  attr_accessor :handler, :body, :request, :response

  def initialize(path, options)
    self.handler = Handler.new

    params = {
      'HTTP_HOST' => 'test.host',
      'REQUEST_PATH' => path,
      'REQUEST_METHOD' => options[:method].to_s.upcase,
    }

    params.merge! options[:headers] if options[:headers]

    body = OpenStruct.new :read => options[:body]
    self.request = OpenStruct.new :params => params, :body => body
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
  attr_accessor :outputter, :status

  def start(status)
    self.status = status
    head = {}
    self.outputter = TestOutputter.new
    yield head, self.outputter
  end
end

