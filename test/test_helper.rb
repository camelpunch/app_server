require 'test/unit'
require 'lib/base'
Server.environment = 'test'
require 'lib/xml'

module ControllerAssertions

  def setup
    @controller_name = self.class.to_s.gsub(/Test$/, '')
    require File.join(File.dirname(__FILE__), '..', 'app', 'controllers', 
                      @controller_name.underscore)
  end

  def controller
    Kernel.const_get(@controller_name).new
  end

  def get(action_name)
    @body = controller.send(action_name)
  end

  def assert_response(type, message = nil)
    case type
    when :success
      assert_equal 200, controller.response.status
    end
  end

end

module ModelAssertions

  def setup
    model_name = self.class.to_s.gsub(/Test$/, '')
    require File.join(File.dirname(__FILE__), '..', 'app', 'models', 
                      model_name.underscore)
  end

end

