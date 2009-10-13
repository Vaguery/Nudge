require 'rubygems'
require 'sinatra'

set :haml, { :format => :html5 } 

get '/' do
  haml :index
  # make couchdb request for since the beginning
  # render page with graph container of those points
end

# post /?last_id=123445
post '/' do
  <<-END
    <svg:g> 
      <svg:rect width="350" height="50" x="20" y="90" fill="blue"></svg:rect> 
      <svg:text x="40" y="120" fill="white" font-weight="bold"> 
        This came from an inline SVG fragment</svg:text> 
    </svg:g> 
  END
  # make a couchdb request for guys since 123445
  # convert to svg data
end