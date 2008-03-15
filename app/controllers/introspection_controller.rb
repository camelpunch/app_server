require 'ostruct'
require 'entry'

class Response < OpenStruct
end

class Controller
  
  def initialize
    self.response = Response.new(:status => 200)
  end

end

class IntrospectionController < Controller

  attr_accessor :response

  def show
    <<XML
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

