require 'rubygems'
require 'sinatra'
require 'environment'

configure do
  set :views, "#{File.dirname(__FILE__)}/views"
end

error do
  e = request.env['sinatra.error']
  Kernel.puts e.backtrace.join("\n")
  e.backtrace.join("\n")
end

helpers do
  def header
    items = []
    items << link_to(SiteConfig.title, "/")
    items << link_to("alphabets", "/") if @alphabet
    items << link_to(@alphabet.name, "/alphabets/#{@alphabet.id}") if @alphabet
    items << "spell" if @query
    items << content_tag(:em, @query.phrase) if @query
    
    content_tag(:ul, convert_to_list_items(items), :id => "header")
  end
  
  def convert_to_list_items(items)
    items.inject([]) do |all, item|
      css = []
      css << "first" if items.first == item
      css << "last" if items.last == item
      all << content_tag(:li, item, :class => css.join(" "))
    end.join("\n")
  end
end

before do
  headers "Content-Type" => "text/html; charset=utf-8"
  @queries = Query.all(:order => [:created_at.desc], :limit => 20)
end

get '/' do
  @alphabets = Alphabet.all
  haml :root
end

post '/spellpost' do
  redirect "/spell/#{params[:phrase]}"
end

get '/spell/:phrase' do
  @query = Query.first(:phrase => params[:phrase]) || Query.new(:phrase => params[:phrase])
  @query.save # This will increment the hit count, whether @query is new or not.
  @alphabets = Alphabet.all
  haml :spell
end

get '/alphabets/:id' do
  @alphabet = Alphabet.get(params[:id])
  haml :alphabet
end

get '/stylesheets/stylesheet.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :stylesheet
end