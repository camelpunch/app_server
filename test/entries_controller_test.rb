require File.dirname(__FILE__) + '/test_helper'
require 'collection'
require 'entry'

class EntriesControllerTest < Test::Unit::TestCase
  include ControllerAssertions

  def load_fixture(container, name)
    klass = Kernel.const_get(container.to_s.singularize.classify)
    klass.destroy name.to_s

    filename = name.split('/').last

    content = fixture "#{container}/#{filename}"
    klass.create :name => name, :content => content
  end

  def assert_include(text)
    assert @body.include?(text), "Expected #{text} to be in:\n #{@body}"
  end

  def assert_not_include(text)
    assert ! @body.include?(text), "Expected #{text} to not be in:\n #{@body}"
  end

  def test_get
    load_fixture :collections, 'blog'
    load_fixture :entries, '/blog/first_post'
    load_fixture :entries, '/code/code_entry'
 
    get '/blog'
    assert_response :success

    assert_equal '/blog', @controller.path

    assert_include '<title type="text">Blog Entries</title>'
    assert_include 'LOL'
    assert_not_include 'Some Code Entry'
  end

end

