require 'sinatra'
require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/books_read.db")

class Book
	include DataMapper::Resource

	property :id, Serial
	property :name, Text, :required => true
	property :complete, Boolean, :required => true, :default => false
	property :created_at, DateTime
	property :updated_at, DateTime
end

DataMapper.finalize.auto_upgrade!

get '/' do
	@books = Book.all :order => :id.desc
	@title = 'All Books'
	erb :home
end

post '/' do
	b = Book.new
	b.name = params[:name]
	b.created_at = Time.now
	b.updated_at = Time.now
	b.save
	redirect '/'
end

get '/:id' do
	@book = Book.get params[:id]
	@title = "Edit note ##{params[:id]}"
	erb :edit
end

put '/:id' do
	b = Book.get params
	b.name = params[:content]
	b.complete = params[:complete] ? 1 : 0
	b.updated_at = Time.now
	b.save
	redirect '/'
end