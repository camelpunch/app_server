require 'entry'

class EntriesController < Controller

  def index
    Xml.open_container 'entries'
    Xml.open_container 'collections'
    render
  end

  def create
    content = request.body.read

    slug = request.params['HTTP_SLUG'] 
    
    entry = Entry.create :name => slug, :content => content

    response.status = 201

    location = [path, slug].join '/'

    response.headers['Location'] = 
      response.headers['Content-Location'] = location

    response.headers["Content-Type"] = "application/atom+xml"

    return entry.document.get_content_as_string
  end
  
end

