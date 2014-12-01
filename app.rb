require 'sinatra'
require 'sinatra/reloader'
require 'soundcloud'

class SoundCloudInstant < Sinatra::Application

  if Sinatra::Base.development?
    require 'dotenv'
    Dotenv.load
    URL = ENV['DEVELOPMENT_URL']
  else
    URL = ENV['PRODUCTION_URL']
  end

  get '/' do
    @widget = Client.widget
    @url = URL
    erb :index
  end

  post '/' do
    query = params[:q]
    @widget = Client.search_track(query)
    response.headers['Access-Control-Allow-Origin'] = '*'
    erb :widget
  end

  Client = SoundCloud.new(:client_id => ENV["CLIENT_ID"])
  class << Client

    DEFAULT_TRACK = "https://soundcloud.com/iamtchami/tchami-untrue-extended-mix"

    def search_track(query)
      resp = self.get('/tracks', :q => query)
      resp.first['uri']
    end

    def widget(track_url = DEFAULT_TRACK)
      resp = self.get('/oembed', :url => track_url)
      resp["html"]
    end

  end

end

SoundCloudInstant.run!
