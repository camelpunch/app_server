require 'entry'

class EntriesController < Controller

  def index
    Xml.open_container 'entries'
    Xml.open_container 'collections'

    response.headers["Content-Type"] = "application/atom+xml"

    render
  end

  def create
    content = request.body.read

    slug = request.params['HTTP_SLUG'] 
    location = [path, slug].join '/'
    
    entry = Entry.create :name => location, :content => content

    response.status = 201

    response.headers['Location'] = 
      response.headers['Content-Location'] = location

    response.headers["Content-Type"] = "application/atom+xml"

    return entry.document.get_content_as_string
  end

  def show
    Entry.find(path) do |entry|
      return entry.document.get_content_as_string
    end
  end
  
end

