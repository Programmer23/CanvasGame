require 'bundler'
Bundler.require

DB = Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://db/main.db')
require './models.rb'

use Rack::Session::Cookie, :key => 'rack.session',
    :expire_after => 2592000,
    :secret => SecureRandom.hex(64)

#include BCrypt

get '/' do
  erb :index
end

post '/' do
  user = User.first(:name => params[:username])
  if user.name == params[:username] && user.password == params[:password]
    redirect '/play'
  else
    @correct = false
    session["message"] = "Username or Password is incorrect"
  end
end

get '/signup' do
  @message = session["message"]
  @correct = true
  session["message"] = nil

  erb :signup
end

post '/signup' do
  if (params[:new_password] == params[:new_password2])
    u = User.new
    u.name = params[:new_username]
    u.password = params[:new_password]
    u.save
  else
    session["message"] = "Passwords do not match"
  end

  redirect '/'
end

get '/play' do
  erb :main
end

get '/leaderboard' do
  erb :highscores
end