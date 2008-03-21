require 'lib/xml'

class Entry < Xml
  self.container_name = 'entries'

  def self.create(options)
    # add / modify extra nodes before creating normally
    content = options[:content]

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

    puts content

    options.merge! :content => content

    super options
  end
end
