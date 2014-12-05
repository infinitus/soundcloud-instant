require 'sinatra'
require 'sinatra/reloader'
require 'soundcloud'
require 'redis'
require 'json'

class SoundCloudInstant < Sinatra::Application

  if Sinatra::Base.development?
    require 'dotenv'
    Dotenv.load
    redis = Redis.new
  else
    redis = Redis.new(:url => ENV['REDISTOGO_URL'])
  end

  configure do
    enable :sessions
    set :session_secret, ENV['SECRET']
  end

  get '/' do
    last_query = redis.get "#{session[:session_id]}:last_query"
    @widget = last_query.nil? ? Client.widget : Client.widget(Client.search_track(last_query).first)
    erb :index
  end

  get '/search' do
    query = params[:q]
    redis.set "#{session[:session_id]}:last_query", query
    response.headers['Access-Control-Allow-Origin'] = '*'
    results = Client.search_track(query)
    results.to_json
  end

  Client = SoundCloud.new(:client_id => ENV["CLIENT_ID"])
  class << Client

    DEFAULT_TRACK = "https://soundcloud.com/iamtchami/tchami-untrue-extended-mix"

    def search_track(query)
      resp = self.get('/tracks', :q => query)
      resp.keep_if(&:streamable).map(&:uri)
    end

    def widget(track_url = DEFAULT_TRACK)
      resp = self.get('/oembed', :url => track_url)
      resp["html"]
    end

  end

end

SoundCloudInstant.run!
