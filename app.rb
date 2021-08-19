require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require 'json'
require 'net/http'

get '/' do
    uri = URI("http://express.heartrails.com/api/json")
    uri.query = URI.encode_www_form({
        method: "getStations",
        x: 139.73,
        y: 35.64
    })
    res = Net::HTTP.get_response(uri)
    json = JSON.parse(res.body)
    @stations = json["response"]["station"]
    erb :index
end
