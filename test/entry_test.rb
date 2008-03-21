require File.dirname(__FILE__) + '/test_helper'

class EntryTest < Test::Unit::TestCase

  def test_create
    name = '/blog/first_post'
    load_fixture :entries, name # does the destroy + creation
    Entry.find(name) do |entry|
      assert_equal name, entry.document.name
      content = entry.document.get_content_as_string
      assert content.include?(name), content
    end
  end

  def test_create_with_existing_self_link
    name = '/blog/first_post'
    load_fixture :entries, name

    Entry.find(name) do |entry|
      content = entry.document.get_content_as_string

      links = content.scan /<link .*rel="self".*/

      assert_equal 1, links.size
    end
  end

  def test_create_adds_updated
    load_fixture :entries, 'with_ns', :dir => :requested_entries
    Entry.find 'with_ns' do |entry|
      assert entry.document.get_content_as_string.include?('<atom:updated')
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

    block_works = false
    Entry.find '/blog/first_post' do |entry|
      block_works = true
    end

    assert block_works
  end
end
