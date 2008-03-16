require File.dirname(__FILE__) + '/test_helper'

class CollectionsControllerTest < Test::Unit::TestCase
  include ControllerTest
  
  def test_get
    Collection.destroy('blog')
    content = fixture 'collections/blog'
    Collection.create(:name => 'blog', :content => content)

    get '/collections'
    assert_response :success

    assert @body.include?('Blog Entries'), 'no Blog Entries in body: ' + @body
  end

end

