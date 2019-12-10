require 'sinatra'
require 'sinatra/contrib/all'
require 'pry'

require_relative('./models/film')
also_reload('./models/*')


get '/' do
  @films = Film.all()
erb(:index)
end


get '/film/:id' do
  @film = Film.find_by_id(params[:id].to_i)
erb(:film)
end
