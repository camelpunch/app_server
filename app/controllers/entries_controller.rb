class EntriesController < Controller

  def index
    Xml.open_container 'entries'
    Xml.open_container 'collections'
    render
  end
  
end

