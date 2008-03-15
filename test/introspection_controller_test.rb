require File.dirname(__FILE__) + '/test_helper'
require 'collection'

class IntrospectionControllerTest < Test::Unit::TestCase
  include ControllerAssertions
  
  def test_get
    Collection.destroy('blog')
    content = <<XML
<collection 
  xmlns="http://www.w3.org/2007/app" 
  xmlns:atom="http://www.w3.org/2005/Atom"
  href="/blog"  
>
  <atom:title>Blog Entries</atom:title>
  <accept>application/atom+xml;type=entry</accept>
  <categories fixed="yes"/>
</collection>
XML
    Collection.create(:name => 'blog', :content => content)

    get :show
    assert_response :success

    assert @body.include?('Blog Entries'), 'no Blog Entries in body: ' + @body
  end

end

