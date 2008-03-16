require File.dirname(__FILE__) + '/test_helper'
require 'collection'

class RoutingTest < Test::Unit::TestCase

  def assert_route(expected_path, options)
    expected_controller, expected_action_name = 
      options.values_at :controller, :action

    fake_request = FakeRequest.new(expected_path)
    assert fake_request.response.outputter.output

    assert_equal expected_controller, 
      fake_request.handler.route.controller.class

    assert_equal expected_action_name.to_s, 
      fake_request.handler.route.controller.action_name
  end

  def test_collections_route
    assert_route '/collections', 
      :controller => CollectionsController,
      :action => :index
  end

  def test_blog_route
    assert_route '/', 
      :controller => EntriesController, 
      :action => :index
  end

end

