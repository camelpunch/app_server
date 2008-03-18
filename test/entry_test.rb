require File.dirname(__FILE__) + '/test_helper'

class EntryTest < Test::Unit::TestCase

  def test_create
    name = '/blog/first_post'
    load_fixture :entries, name
    Entry.find(name) do |entry|
      assert_equal name, entry.document.name
    end
  end

  def test_count
    name = '/blog/first_post'
    Entry.destroy name
    num_entries = Entry.count
    load_fixture :entries, name
    assert_equal num_entries+1, Entry.count
  end

  def test_find_missing
    assert_raise Entry::NotFound do
      Entry.find('dfgdhjrereljlt') {}
    end
  end

  def test_find_transaction
    load_fixture :entries, '/blog/first_post'
    Entry.find '/blog/first_post' do |entry|
      contents = File.read(File.join(File.dirname(__FILE__),
                                     '/fixtures/blog/first_post'))
      assert_equal contents, entry.document.get_content_as_string
    end
  end
end
