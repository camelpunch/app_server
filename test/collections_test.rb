require File.dirname(__FILE__) + '/test_helper'

class CollectionTest < Test::Unit::TestCase

  def test_names
    load_fixture :collections, 'blog'
    
    assert Collection.names.size > 0
    assert Collection.names.include?('blog')
  end

end
