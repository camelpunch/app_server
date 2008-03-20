require 'lib/xml'

class Collection < Xml
  self.container_name = 'collections'

  def self.names
    # should be a way of doing this with getAllDocuments and getName,
    # but I can't figure out how to use DocumentConfig, required by the former
    names = query <<XQUERY
declare default element namespace "http://www.w3.org/2007/app";
string-join(collection("dbxml:collections")
            /collection/dbxml:metadata("dbxml:name"),
            ',')
XQUERY

    return names.split(',')
  end
end
