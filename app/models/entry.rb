require 'lib/xml'
class Entry < Xml

  import java.io.FileOutputStream
  import javax.xml.transform.stream.StreamSource
  import javax.xml.transform.TransformerFactory
  import javax.xml.transform.stream.StreamResult
  import java.lang.System

  self.container_name = 'entries'

  def self.create(options)

    # use saxon for XSLT 2 support
    System.set_property("javax.xml.transform.TransformerFactory",
                        "net.sf.saxon.TransformerFactoryImpl")

    # pass to xslt processor to do transformations before saving
    content = options[:content]

    stylesheet_path = 
      File.join(Server.root, 'app', 'stylesheets', 'create_entry.xsl')

    reader = StringReader.new(content)
    document = StreamSource.new(reader) 
    stylesheet = StreamSource.new(stylesheet_path)
    output = StringWriter.new

    result = StreamResult.new output

    transformer = TransformerFactory.new_instance.new_transformer(stylesheet)
    transformer.set_parameter('name', options[:name])
    transformer.transform(document, result)

    options.merge! :content => output.to_s

    super options

  rescue java.lang.Exception => e
    puts e
  end
end
