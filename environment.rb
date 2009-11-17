require 'rubygems'
require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'dm-aggregates'
require 'dm-serializer'
require 'haml'
require 'ostruct'

require 'sinatra' unless defined?(Sinatra)

gem 'ratpack'
gem 'sinatra-content-for'
require 'sinatra/ratpack'
require 'sinatra/content_for'

configure do
  SiteConfig = OpenStruct.new(
                 :title => 'Acrophonics',
                 :author => 'Zeke Sikelianos',
                 :url_base => 'http://localhost:4567/'
               )

  DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3:///#{File.expand_path(File.dirname(__FILE__))}/#{Sinatra::Base.environment}.db")

  # load models
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
  Dir.glob("#{File.dirname(__FILE__)}/lib/*.rb") { |lib| require File.basename(lib, '.*') }
end
