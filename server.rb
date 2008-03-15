require 'base'

class Introspection < Mongrel::HttpHandler
  def process(request, response)
    response.start(200) do |head,out|
      body = <<XML
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
      head["Content-Type"] = "application/atomserv+xml"
      head["ETag"] = MD5.new body
      head["Content-Encoding"] = "deflate"

      out.write Zlib::Deflate.deflate(body)
    end
  end
end

class Entry < Mongrel::HttpHandler
  def process(request, response)
    response.start(200) do |head,out|
      body = <<XML
<?xml version="1.0" ?><feed xmlns="http://www.w3.org/2005/Atom" xmlns:app="http://www.w3.org/2007/app">
<title type="text">BitWorking | Joe Gregorio</title>
<link href="http://bitworking.org/projects/apptestsite/app.cgi/service/entry/" rel="self"/>
<link href="http://bitworking.org/" rel="alternate"/>
<icon>http://bitworking.org/favicon.ico</icon>
<updated>2008-02-28T09:57:08.303337-04:00</updated>
<author>
<name>Joe Gregorio</name>
</author>
<id>http://bitworking.org/</id>
<entry>
<title>Iñtërnâtiônàlizætiøn - 3</title>
<link href="http://bitworking.org/news/135/eadledkeai"/>
<link href="135/" rel="edit"/>
<link href="135/;media" rel="edit-media"/>
<id>http://bitworking.org/news/135/eadledkeai</id>
<updated>2008-02-28T09:57:08.303337-04:00</updated>
<app:edited>2008-02-28T09:57:08.303337-04:00</app:edited>
<summary type="xhtml">
<div xmlns="http://www.w3.org/1999/xhtml"/>
</summary>
<content type="xhtml">
<div xmlns="http://www.w3.org/1999/xhtml"><p><i>A test of utf-8</i></p></div>
</content>
</entry><entry>
<title>Iñtërnâtiônàlizætiøn - 2</title>
<link href="http://bitworking.org/news/134/dlejicgkgh"/>
<link href="134/" rel="edit"/>
<link href="134/;media" rel="edit-media"/>
<id>http://bitworking.org/news/134/dlejicgkgh</id>
<updated>2008-02-28T09:57:07.789742-04:00</updated>
<app:edited>2008-02-28T09:57:07.789742-04:00</app:edited>
<summary type="xhtml">
<div xmlns="http://www.w3.org/1999/xhtml"/>
</summary>
<content type="xhtml">
<div xmlns="http://www.w3.org/1999/xhtml"><p><i>A test of utf-8</i></p></div>
</content>
</entry><entry>
<title>Iñtërnâtiônàlizætiøn - 1</title>
<link href="http://bitworking.org/news/133/gcdfhccjji"/>
<link href="133/" rel="edit"/>
<link href="133/;media" rel="edit-media"/>
<id>http://bitworking.org/news/133/gcdfhccjji</id>
<updated>2008-02-28T09:57:07.112218-04:00</updated>
<app:edited>2008-02-28T09:57:07.112218-04:00</app:edited>
<summary type="xhtml">
<div xmlns="http://www.w3.org/1999/xhtml"/>
</summary>
<content type="xhtml">
           <div xmlns="http://www.w3.org/1999/xhtml"><p><i>A test of utf-8</i></p></div>
                    </content>
                       </entry><entry>
                            <title>Iñtërnâtiônàlizætiøn</title>
<link href="http://bitworking.org/news/18/I-t-rn-ti-n-liz-ti-n"/>
<link href="18/" rel="edit"/>
<link href="18/;media" rel="edit-media"/>
<id>http://bitworking.org/news/18/I-t-rn-ti-n-liz-ti-n</id>
<updated>2008-02-26T10:07:50.728886-04:00</updated>
<app:edited>2008-02-26T10:07:50.728886-04:00</app:edited>
<summary type="xhtml">
<div xmlns="http://www.w3.org/1999/xhtml"/>
</summary>
<content type="xhtml">
<div xmlns="http://www.w3.org/1999/xhtml"><p><i>A test of utf-8</i></p></div>
</content>
</entry><entry>
<title>Iñtërnâtiônàlizætiøn</title>
<link href="http://bitworking.org/news/17/I-t-rn-ti-n-liz-ti-n"/>
<link href="17/" rel="edit"/>
<link href="17/;media" rel="edit-media"/>
<id>http://bitworking.org/news/17/I-t-rn-ti-n-liz-ti-n</id>
<updated>2008-02-26T10:07:50.155465-04:00</updated>
<app:edited>2008-02-26T10:07:50.155465-04:00</app:edited>
<summary type="xhtml">
<div xmlns="http://www.w3.org/1999/xhtml"/>
</summary>
<content type="xhtml">
<div xmlns="http://www.w3.org/1999/xhtml"><p><i>A test of utf-8</i></p></div>
</content>
</entry><entry>
<title>Iñtërnâtiônàlizætiøn</title>
<link href="http://bitworking.org/news/16/I-t-rn-ti-n-liz-ti-n"/>
<link href="16/" rel="edit"/>
<link href="16/;media" rel="edit-media"/>
<id>http://bitworking.org/news/16/I-t-rn-ti-n-liz-ti-n</id>
<updated>2008-02-26T10:07:49.620100-04:00</updated>
<app:edited>2008-02-26T10:07:49.620100-04:00</app:edited>
<summary type="xhtml">
<div xmlns="http://www.w3.org/1999/xhtml"/>
</summary>
<content type="xhtml">
           <div xmlns="http://www.w3.org/1999/xhtml"><p><i>A test of utf-8</i></p></div>
                    </content>
                       </entry>
                       </feed>

XML
      head["Content-Type"] = "application/atomserv+xml"
      head["ETag"] = MD5.new body
      head["Content-Encoding"] = "deflate"

      out.write Zlib::Deflate.deflate(body)
    end
  end
end

h = Mongrel::HttpServer.new("0.0.0.0", 3000)
h.register("/introspection", Introspection.new)
h.register("/entry", Entry.new)
puts "loaded"
h.run.join
