require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require 'sinatra/json'
require './models/contribution.rb'

before do


end

get '/' do
    @contents = Contribution.all.order('id desc')
    erb :index
end

post '/new' do
    Contribution.create({
        name: params[:user_name],
        body: params[:body]
    })
    redirect '/'
end

post '/good/:id' do
    content = Contribution.find(params[:id])
    good = content.good
    content.update({
        good: good + 1
    })
    redirect '/'
end
    
post '/delete/:id' do
    Contribution.find(params[:id]).destroy
    redirect '/'
end

get '/edit/:id' do
    @content = Contribution.find(params[:id])
    erb :edit
end