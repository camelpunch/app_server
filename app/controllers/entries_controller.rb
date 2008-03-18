require 'entry'

class EntriesController < Controller

  def index
    Xml.open_container 'entries'
    Xml.open_container 'collections'
    render
  end

  def create
    entry = Entry.create :name => request.params['HTTP_SLUG'], 
                         :content => '<adsf/>'

    response.status = 201
    entry.document.get_content_as_string
  end
  
end

