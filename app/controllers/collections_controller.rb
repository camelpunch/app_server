class CollectionsController < Controller

  def index
    Xml.open_container 'collections'
    render
  end
  
end

