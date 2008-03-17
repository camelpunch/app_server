class EntriesController < Controller

  def index
    Xml.open_container 'entries'
    Xml.open_container 'collections'
    render
  end

  def create
    response.status = 201
  end
  
end

