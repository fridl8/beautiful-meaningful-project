# Set up gems listed in the Gemfile.
# See: http://gembundler.com/bundler_setup.html
#      http://stackoverflow.com/questions/7243486/why-do-you-need-require-bundler-setup
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

# Require gems we care about
require 'rubygems'
require 'dotenv'
require 'uri'
require 'pathname'
require 'bcrypt'

require 'pg'
require 'active_record'
require 'logger'

require 'sinatra'
require "sinatra/reloader" if development?
require 'oauth2'
require 'json'

require 'erb'
# require 'pry-byebug'

# API
Dotenv.load

SCOPES = [
  'https://www.googleapis.com/auth/userinfo.email'
].join(' ')

unless G_API_CLIENT = ENV['G_API_CLIENT']
  raise "You must specify the G_API_CLIENT env variable"
end

unless G_API_SECRET = ENV['G_API_SECRET']
  raise "You must specify the G_API_SECRET env variable"
end

def client
  client ||= OAuth2::Client.new(G_API_CLIENT, G_API_SECRET, {
                :site => 'https://accounts.google.com',
                :authorize_url => "/o/oauth2/auth",
                :token_url => "/o/oauth2/token"
              })
end

def redirect_uri
  uri = URI.parse(request.url)
  uri.path = '/oauth2callback'
  uri.query = nil
  uri.to_s
end

# Some helper constants for path-centric logic
APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))

APP_NAME = APP_ROOT.basename.to_s

configure do
  # By default, Sinatra assumes that the root is the file that calls the configure block.
  # Since this is not the case for us, we set it manually.
  set :root, APP_ROOT.to_path
  # See: http://www.sinatrarb.com/faq.html#sessions
  enable :sessions
  set :session_secret, ENV['SESSION_SECRET'] || 'this is a secret shhhhh'

  # Set the views to
  set :views, File.join(Sinatra::Application.root, "app", "views")
end

# Set up the controllers and helpers
Dir[APP_ROOT.join('app', 'controllers', '*.rb')].each { |file| require file }
Dir[APP_ROOT.join('app', 'helpers', '*.rb')].each { |file| require file }

# Set up the database and models
require APP_ROOT.join('config', 'database')
