require 'sinatra'
require 'sass'
require 'json'

get '/' do
  erb :index
end

post '/' do
  input = params[:code]
  
  prefix = 'body{color:' # Arbitrary prefix
  suffix = '}' # Arbitrary suffix
  
  begin
    compressed_result = Sass.compile("#{prefix}#{input}#{suffix}", :style => :compressed) # Compile compressed with prefix/suffix
  rescue => e # Capture errors
    compressed_result = e.message # Display error
  end
  
  output = compressed_result.gsub(/(#{prefix}|#{suffix})/, '') # Strip out prefix/suffix
  
  # Check if color function
  spaceless_input = input.gsub(/ /, '') # An input with no spaces
  regex_color_function = /(^\w+\(#?\w+,(\d+.?\d%?)\)|^\w+\(#?\w+\))/
  if regex_color_function =~ spaceless_input
    spaceless_input.gsub(/\((?<function>#?\w+)/) {
      @original_color = $1
    }
  end
  
  content_type :json # Return content type json
  # Return json
  { 
    :output => output,
    :original_color => (@original_color || '')
  }.to_json
end

# Stylesheet compile/compress
get '/stylesheets/:basename.css' do
  @file = File.new("stylesheets/#{params[:basename]}.scss")
  
  last_modified @file.mtime
  
  scss @file.read, :style => :compressed
end