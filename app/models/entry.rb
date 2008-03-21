require 'lib/xml'
import java.io.FileOutputStream
import javax.xml.transform.stream.StreamSource
import javax.xml.transform.TransformerFactory

class Entry < Xml
  self.container_name = 'entries'

  def self.create(options)
    # pass to xslt processor to do necessary transformations before saving
    content = options[:content]

    stylesheet_path = 
      File.join(Server.root, 'app', 'stylesheets', 'create_entry.xsl')

    puts stylesheet_path

    reader = StringReader.new(content)
    document = StreamSource.new(reader) 
    stylesheet = StreamSource.new(stylesheet_path)
    output = StringWriter.new

    result = javax.xml.transform.stream.StreamResult.new output

    transformer = TransformerFactory.newInstance.newTransformer(stylesheet)
    transformer.transform(document, result)

=begin
    self_links = content.scan /<.*link .*rel="self".*/

    if self_links.size == 0
      content.gsub! /<\/entry>/, <<FRAGMENT
<link rel="self" href="#{options[:name]}"/>
</entry>
FRAGMENT

      content.gsub! /<\/atom:entry>/, <<FRAGMENT
<atom:link rel="self" href="#{options[:name]}"/>
</atom:entry>
FRAGMENT
    end
=end

    options.merge! :content => output

    super options
  end
end
