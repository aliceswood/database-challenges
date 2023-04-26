require_relative './book'

class BookRepository
  def all
    book_list = []

    sql = 'SELECT id, title, author_name FROM books;'
    result_set = DatabaseConnection.exec_params(sql, [])

    result_set.each do |record|
      book = Book.new
      book.id = record['id']
      book.title = record['title']
      book.author_name = record['author_name']

      book_list << book
    end
    return book_list
  end
end