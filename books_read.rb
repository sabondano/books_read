require 'sinatra'
require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/boos_read.db")

class Book
	include DataMapper::Resource

	property :id, Serial
	property :title, Text, :required => true
	property :finished, Boolean, :required => true, :default => false
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
	b.title = params[:title]
	b.created_at = Time.now
	b.updated_at = Time.now
	b.save
	redirect '/'
end
