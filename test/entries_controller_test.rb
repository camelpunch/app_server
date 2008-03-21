require File.dirname(__FILE__) + '/test_helper'

class EntriesControllerTest < Test::Unit::TestCase
  include ControllerTest

  def setup
    @new_name = 'a_name_for_my_post'
    begin
      Entry.destroy @new_name
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

  def test_show
    load_fixture :collections, 'blog'
    load_fixture :entries, '/blog/first_post'

    get '/blog/first_post'
    assert_response 200

    assert_include 'first post</title>'
  end

  def test_create_with_slug
    assert_posts do
      post '/blog', 
        :headers => { 'HTTP_SLUG' => @new_name },
        :body => fixture('requested_entries/somenewpost')
    end
  end

  def test_create_without_slug
    assert_posts(:expected_location => '/blog/some_new_post') do
      post '/blog', :body => fixture('requested_entries/somenewpost')
    end
  end

  def test_create_with_explicit_namespaces
    assert_posts(:expected_location => '/blog/with_ns') do
      post '/blog',
        :body => fixture('requested_entries/with_ns')
    end
  end

  protected

  def assert_posts(options = {})
    expected_location = options[:expected_location] || "/blog/#{@new_name}"

    begin
      Entry.destroy expected_location
    rescue
    end

    num_entries = Entry.count

    yield

    assert_response 201
    assert_not_nil @body, "body was nil"

    assert_equal num_entries + 1, Entry.count

    assert_equal "application/atom+xml", @headers['Content-Type']

    assert_equal expected_location, @headers['Location']
    assert_equal expected_location, @headers['Content-Location']
    assert_include "link rel=\"self\" href=\"#{expected_location}\"/>"

    Entry.find(expected_location) {|entry| assert entry.kind_of?(Entry)}

    assert_include expected_location
  end

end

