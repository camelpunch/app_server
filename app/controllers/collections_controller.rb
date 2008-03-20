class CollectionsController < Controller

  def index
    Xml.open_container 'collections'
    response.headers["Content-Type"] = "application/atomserv+xml"
    render
  end
  
end

