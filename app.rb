require 'sinatra'
require 'sinatra/reloader'
require 'soundcloud'
require 'dotenv'

Dotenv.load

CLIENT_ID = ENV['CLIENT_ID']

get '/' do
  @widget = SoundCloundClient.new(CLIENT_ID).track_html
  erb :index
end

get '/search' do
  @foo = params[:q]
  erb :index
  # @result = SoundCloundClient.new(CLIENT_ID).search
end

class SoundCloundClient

  attr_accessor :client
  DEFAULT_TRACK = "https://soundcloud.com/iamtchami/tchami-untrue-extended-mix"
  
  def initialize(client_id)
    @client ||= SoundCloud.new(:client_id => CLIENT_ID)
  end

  def track_html(track_url = DEFAULT_TRACK)
    resp = @client.get('/oembed', :url => track_url)
    resp["html"]
  end

end

