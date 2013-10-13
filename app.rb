require 'sinatra'
require 'sinatra/activerecord'
set :database, ENV['DATABASE_URL'] || "sqlite3:///db/craigslist_jr.db"

class Item < ActiveRecord::Base
end

get '/' do
  @items=Item.all
  erb :index
end

get '/item/new' do
  erb :item_new
end

get '/item/:item_url' do
  @item = find_item_from(params[:item_url])
  erb :item_view
end

post '/item/new' do
  item_url = create_secure_url
  item = Item.create(title: params[:title], price: params[:price], description: params[:desc], url: item_url)

  redirect "/item/#{item.url}"
end

get '/item/edit/:item_url' do
  @item = find_item_from(params[:item_url])
  erb :item_edit
end

post '/item/update/:item_url' do
  @item = find_item_from(params[:item_url])
  @item.title = params[:title]
  @item.price = params[:price]
  @item.description = params[:desc]
  @item.save

  redirect "/item/#{@item.url}"
end

helpers do
  def create_secure_url
    require 'securerandom'
    SecureRandom.hex
  end

  def find_item_from(secure_url)
    Item.where("url = ?", secure_url).first
  end
end