require 'sinatra'
require 'sinatra/reloader'
require 'soundcloud'

if Sinatra::Base.development?
  require 'dotenv'
  Dotenv.load
  URL = 'http://localhost:4567'
else
  URL = 'http://soundcloudinstant.herokuapp.com'
end

get '/' do
  @widget = Client.track_html
  @url = URL
  erb :index
end

post '/' do
  query = params[:q]

  # TODO: DRY this.
  permalink = Client.search_track(query)
  @widget = Client.track_html(permalink, true)
  p @widget

  response.headers['Access-Control-Allow-Origin'] = '*'

  erb :widget
end

Client = SoundCloud.new(:client_id => ENV["CLIENT_ID"])
class << Client

  DEFAULT_TRACK = "https://soundcloud.com/iamtchami/tchami-untrue-extended-mix"

  def search_track(query)
    resp = self.get('/tracks', :q => query)
    resp.first["permalink_url"]
  end

  def track_html(track_url = DEFAULT_TRACK, autoplay_enabled = false)
    resp = self.get('/oembed', :url => track_url, :auto_play => autoplay_enabled)
    resp["html"]
  end

end
