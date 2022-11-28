class BookRequest < ApplicationRecord
  self.table_name='book_request'
  belongs_to :books
  belongs_to :librarians
  belongs_to :students

end
