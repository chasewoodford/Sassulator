require 'sinatra'
require 'sass'

get '/' do
  erb :index
end

post '/' do
  input = 'lighten(#333, 10%)' # Input value
  input = params[:code]
  
  if input != ''
    prefix = 'body{color:'
    suffix = '}'
    
    compressed_result = Sass.compile("#{prefix}#{input}#{suffix}", :style => :compressed) # Compile compressed with prefix/suffix
    output = compressed_result.gsub(/(#{prefix}|#{suffix})/, '') # Strip out prefix/suffix
    
    output
  end
end