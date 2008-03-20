require File.dirname(__FILE__) + '/test_helper'

class CollectionsControllerTest < Test::Unit::TestCase
  include ControllerTest
  
  def test_get
    Collection.destroy('blog')
    content = fixture 'collections/blog'
    Collection.create(:name => 'blog', :content => content)

    get '/collections'
    assert_response 200

    assert_equal 'application/atomserv+xml', 
      @controller.response.headers['Content-Type']

    assert @body.include?('Blog Entries'), 'no Blog Entries in body: ' + @body

    assert_valid :app, @body
  end

end

