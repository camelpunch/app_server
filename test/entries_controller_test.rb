require File.dirname(__FILE__) + '/test_helper'

class EntriesControllerTest < Test::Unit::TestCase
  include ControllerTest

  def test_get
    load_fixture :collections, 'blog'
    load_fixture :entries, '/blog/first_post'
    load_fixture :entries, '/code/code_entry'

    get '/blog'
    assert_response 200

    assert_equal '/blog', @controller.path

    assert_include '<title type="text">Blog Entries</title>'
    assert_include 'LOL'
    assert_not_include 'Some Code Entry'

    assert_include "http://test.host#{@controller.path}"

    assert_valid :atom, @body
  end

  def test_post
    slug = 'a_name_for_my_post'
    begin
      Entry.destroy(slug)
    rescue
    end

    assert_raise Entry::NotFound do
      Entry.find(slug) {}
    end

    num_entries = Entry.count

    post '/blog', 
      :headers => { :slug => slug },
      :content => fixture('requested_entries/somenewpost')

    assert_response 201

    assert_equal num_entries + 1, Entry.count

    Entry.find(slug) do |entry|
      assert_equal entry.document.get_content_as_string, @body
    end
  end
end

