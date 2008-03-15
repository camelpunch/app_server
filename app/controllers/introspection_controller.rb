class IntrospectionController < Controller

  def show
    Xml.open_container 'collections'
    render
  end
  
end

