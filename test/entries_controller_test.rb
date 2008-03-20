require File.dirname(__FILE__) + '/test_helper'

class EntriesControllerTest < Test::Unit::TestCase
  include ControllerTest

  def setup
    @slug = 'a_name_for_my_post'
    begin
      Entry.destroy @slug
    rescue
    end
  end

  def test_index
    load_fixture :collections, 'blog'
    load_fixture :entries, '/blog/first_post'
    load_fixture :entries, '/code/code_entry'

    get '/blog'
    assert_response 200

    assert_equal 'application/atom+xml', 
      @controller.response.headers['Content-Type']

    assert_equal '/blog', @controller.path

    assert_include '<title type="text">Blog Entries</title>'
    assert_include 'LOL'
    assert_not_include 'Some Code Entry'

    assert_include "http://test.host#{@controller.path}"

    assert_valid :atom, @body
  end

  def test_index_when_empty
    load_fixture :collections, 'empty'

    get '/empty'
    assert_response 200

    assert_include '<updated'

    assert_valid :atom, @body
  end

  def test_post
    expected_location = "/blog/#{@slug}"

    begin
      Entry.destroy expected_location
    rescue
    end

    num_entries = Entry.count

    post '/blog', 
      :headers => { 'HTTP_SLUG' => @slug },
      :body => fixture('requested_entries/somenewpost')

    assert_response 201
    assert_not_nil @body, "body was nil"

    assert_equal num_entries + 1, Entry.count

    assert_equal "application/atom+xml", @headers['Content-Type']

    assert_equal expected_location, @headers['Location']
    assert_equal expected_location, @headers['Content-Location']
    assert_include "<link rel=\"self\" href=\"#{expected_location}\"/>"

    Entry.find(expected_location) {|entry| assert entry.kind_of?(Entry)}

    assert_include '<title>Some New Post</title>'
    assert_include expected_location
  end
end

