require File.dirname(__FILE__) + '/test_helper'

class EntriesControllerTest < Test::Unit::TestCase
  include ControllerTest

  def test_get
    load_fixture :collections, 'blog'
    load_fixture :entries, '/blog/first_post'
    load_fixture :entries, '/code/code_entry'

    get '/blog'
    assert_response :success

    assert_equal '/blog', @controller.path

    assert_include '<title type="text">Blog Entries</title>'
    assert_include 'LOL'
    assert_not_include 'Some Code Entry'

    assert_include '<id'

    assert_valid :app, @body
  end

end

