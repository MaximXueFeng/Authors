require 'sinatra' 
require 'pg'

set :bind, '0.0.0.0'
set :port, 3000 

connection = PG::connect(dbname: 'test', user: 'postgres', password: 'qwerty')

get '/' do
  @authors = connection.exec('SELECT * FROM authors')

  erb :index
end

get '/authors/:id' do
  @author = connection.exec_params("SELECT authors.* FROM authors WHERE authors.id = $1::int", [params[:id]]).first
  @books = connection.exec_params("SELECT books.* FROM books
  JOIN authors_books ON books.id = authors_books.book_id
  WHERE authors_books.author_id = $1::int", [params[:id]])

  erb :author
end

get '/books/:id' do
  @book = connection.exec_params("SELECT books.* FROM books WHERE books.id = $1::int", [params[:id]]).first
  @screen_adaptations = connection.exec_params("SELECT screen_adaptations.* FROM screen_adaptations
  WHERE screen_adaptations.book_id = $1::int", [params[:id]])

  erb :book
end
