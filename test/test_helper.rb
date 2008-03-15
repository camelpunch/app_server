require 'test/unit'
require 'rubygems'
require 'active_support'

module ControllerAssertions

  def controller
    controller_name = self.class.to_s.gsub(/Test$/, '')
    require File.join(File.dirname(__FILE__), '..', 'app', 'controllers', 
                      controller_name.underscore)
    Kernel.const_get(controller_name).new
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


