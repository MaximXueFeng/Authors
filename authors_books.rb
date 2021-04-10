require 'sinatra' 
require 'pg'

set :bind, '0.0.0.0'
set :port,3000 

conection = PG.connect dbname: 'test', user: 'postgres', password: 'qwerty'

get '/' do
  @authors = conection.exec 'SELECT * FROM authors'

  erb :index
end

get '/authors/:id' do
  @author = conection.exec("SELECT authors.* FROM authors WHERE authors.id = #{params[:id]}").first
  @books = conection.exec "SELECT books.* FROM books
  JOIN authors_books ON books.id = authors_books.book_id
  WHERE authors_books.author_id = #{params[:id]}"

  erb :author
end

get '/books/:id' do
  @author = conection.exec("SELECT authors.* FROM authors WHERE authors.id = #{params[:id]}").first
  @book = conection.exec("SELECT books.* FROM books WHERE books.id = #{params[:id]}").first
  @screen_adaptations = conection.exec "SELECT screen_adaptations.* FROM screen_adaptations
  WHERE screen_adaptations.book_id = #{params[:id]}"

  erb :book
end

