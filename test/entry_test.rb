require File.dirname(__FILE__) + '/test_helper'
require File.join(Server.root, 'app', 'models', 'entry')

class EntryTest < Test::Unit::TestCase
  include ModelAssertions

  def test_create
    Entry.destroy('test')
    content = <<XML
<?xml version="1.0" encoding="utf-8"?>
<entry xmlns="http://www.w3.org/2005/Atom">
  <title>Test</title>
  <link href="http://www.andrewbruce.net/test"/>
  <id>aasdfasdffsd</id>
  <updated>Today</updated>
  <summary>asdf</summary>
</entry>
XML
    Entry.create(:name => 'test', :content => content)

    e = Entry.find('test')

    assert_equal 'test', e.document.name
  end

end
