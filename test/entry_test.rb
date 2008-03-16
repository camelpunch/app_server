require File.dirname(__FILE__) + '/test_helper'

class EntryTest < Test::Unit::TestCase

  def test_create
    load_fixture :entries, '/blog/first_post'
    e = Entry.find('/blog/first_post')
    assert_equal '/blog/first_post', e.document.name
  end

end
