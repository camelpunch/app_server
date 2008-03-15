require File.dirname(__FILE__) + '/test_helper'

class IntrospectionControllerTest < Test::Unit::TestCase
  include ControllerAssertions
  
  def test_get
    get :show
    assert_response :success

    assert @body.include?('<service')
  end

end

