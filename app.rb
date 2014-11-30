require 'sinatra'
require 'sinatra/reloader'
require 'soundcloud'
require 'pp'

if Sinatra::Base.development?
  require 'dotenv'
  Dotenv.load
  URL = 'http://localhost:4567'
else
  URL = 'http://soundcloudinstant.herokuapp.com'
end

CLIENT_ID = ENV['CLIENT_ID']
DEFAULT_TRACK = "https://soundcloud.com/iamtchami/tchami-untrue-extended-mix"

get '/' do
  client = SoundCloudClient.new(CLIENT_ID)
  @widget = client.track_html
  @url = URL
  erb :index
end

post '/search' do
  query = params[:q]

  # TODO: DRY this.
  client = SoundCloudClient.new(CLIENT_ID)
  permalink = client.search_track(query)
  p permalink
  @widget = client.track_html(permalink)
  erb :widget
end

class SoundCloudClient

  attr_accessor :client

  def initialize(client_id)
    @client ||= SoundCloud.new(:client_id => CLIENT_ID)
  end

  def search_track(query)
    resp = client.get('/tracks', :q => query)
    resp.first["permalink_url"]
  end

  def track_html(track_url = DEFAULT_TRACK)
    resp = @client.get('/oembed', :url => track_url)
    resp["html"]
  end

end
