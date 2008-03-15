require File.dirname(__FILE__) + '/test_helper'

class IntrospectionControllerTest < Test::Unit::TestCase
  include ControllerAssertions
  
  def test_get
    Entry.destroy('some_doc')
    Entry.create(:name => 'some_doc', :content => '<balls/>')

    get :show
    assert_response :success

    assert @body.include?('<service')
  end

end

