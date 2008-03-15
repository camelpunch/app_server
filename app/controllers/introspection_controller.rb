require 'ostruct'

class Response < OpenStruct
end

class IntrospectionController

  attr_accessor :response

  def initialize
    self.response = Response.new(:status => 200)
  end

  def show
    <<XML
<?xml version="1.0" encoding="utf-8"?>
<service xmlns="http://www.w3.org/2007/app" xmlns:atom="http://www.w3.org/2005/Atom">
  <workspace>
    <atom:title>AtomPub Test Site</atom:title>
      <collection href="entry/">
           <atom:title>entry</atom:title>
           <accept>application/atom+xml;type=entry</accept>
         <categories fixed="yes" />
      </collection>
      <collection href="draft/">
           <atom:title>draft</atom:title>
           <accept>application/atom+xml;type=entry</accept>
         <categories fixed="yes" />
      </collection>
      <collection href="trash/">
           <atom:title>trash</atom:title>
           <accept>application/atom+xml;type=entry</accept>
         <categories fixed="yes" />
      </collection>
      <collection href="media/">
           <atom:title>media</atom:title>
        <accept>*/*</accept>
         <categories fixed="yes" />
      </collection>
      <collection href="trash/">
           <atom:title>trash</atom:title>
        <accept>*/*</accept>
         <categories fixed="yes" />
      </collection>
  </workspace>
</service>
XML
  end
  
end

