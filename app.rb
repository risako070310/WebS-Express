require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require 'json'
require 'net/http'
require 'sinatra/activerecord'
require './models'

get '/' do
    @histories = History.all
    @favorites = History.where(favorite: true)
    erb :form
end

get '/list' do
    @x = params[:x]
    @y = params[:y]
    History.create!(x: @x, y: @y)
    uri = URI("http://express.heartrails.com/api/json")
    uri.query = URI.encode_www_form({
        method: "getStations",
        x: @x,
        y: @y
    })
    res = Net::HTTP.get_response(uri)
    json = JSON.parse(res.body)
    @stations = json["response"]["station"]
    erb :list
end

get '/api/station' do
    uri = URI("http://express.heartrails.com/api/json")
    uri.query = URI.encode_www_form({
        method: "getStations",
        line: params[:line],
        name: params[:name]
    })
    res = Net::HTTP.get_response(uri)
    json = JSON.parse(res.body)
    if json["response"]["error"]
        response = { error: "No Station." }
    else 
        response = {
            next: json["response"]["station"][0]["next"],
            prev: json["response"]["station"][0]["prev"]
        }
    end
    json response
end

post '/:id/delete' do
    history = History.find(params[:id])
    history.delete
    redirect "/"
end

post '/:id/update' do
    history = History.find(params[:id])
    history.favorite = !history.favorite
    history.save
    redirect "/"
end