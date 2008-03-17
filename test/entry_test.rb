require File.dirname(__FILE__) + '/test_helper'

class EntryTest < Test::Unit::TestCase

  def test_create
    load_fixture :entries, '/blog/first_post'
    e = Entry.find('/blog/first_post')
    assert_equal '/blog/first_post', e.document.name
  end

  def test_count
    name = '/blog/first_post'
    Entry.destroy name
    num_entries = Entry.count
    load_fixture :entries, name
    assert_equal num_entries+1, Entry.count
  end
end
