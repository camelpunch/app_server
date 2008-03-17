require File.dirname(__FILE__) + '/test_helper'

class ControllerBaseTest < Test::Unit::TestCase

  def setup
    @request = OpenStruct.new :params => {
      'HTTP_HOST' => 'bums.com',
      'REQUEST_PATH' => '/',
    }
    @controller = Controller.new(@request)
  end
  
  def test_hostname
    assert_equal @request, @controller.request
    assert_equal @request.params['HTTP_HOST'], @controller.hostname
  end

  def test_path
    assert_equal @request.params['REQUEST_PATH'], @controller.path
  end

end

