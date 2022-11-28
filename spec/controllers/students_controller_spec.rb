require 'rails_helper'

RSpec.describe StudentsController, type: :controller do
  context 'GET#index' do
    it 'test if list of students can be seen' do
      redirect_to students_path
      expect(response).to be_success
    end
  end

  context 'GET#show' do
    it 'test if a students details can be viewed' do
      student = Student.create(name: 'Student1', email: 'student1@g.com', university: 'NCSU', education: 'Undergraduate', max_books: 2)
      redirect_to student_path(student)
      expect(response).to be_success
    end
  end

  student = Student.create(name: 'Student1', email: 'student1@g.com', university: 'NCSU', education: 'Undergraduate', max_books: 2)
  # book = Book.create(isbn: '123-276-5929', title: 'Title 1', author: 'author 1', language: 'english', published: '2018-08-12', edition: 6, subject: 'Test subject', summary: 'Test summary', special_collection: false, book_count: 5, is_issued: false, number_hold_req: 0, available_count: 5, libraries_id: 3)

  context 'GET#create_book' do
    it 'tests if a new book is created' do
      book1 = Book.create(isbn: '123-276-5929', title: 'Title 1', author: 'author 1', language: 'english', published: '2018-08-12', edition: 6, subject: 'Test subject', summary: 'Test summary', special_collection: false, book_count: 5, is_issued: false, number_hold_req: 0, available_count: 5, libraries_id: 3)
      # puts Book.where(edition: 6).to_yaml
      book1.edition.to_i > 6
    end
  end

  context 'GET#request_book' do
    it 'test if student can request book' do
      book = Book.create(isbn: '123-276-5929', title: 'Title 1', author: 'author 1', language: 'english', published: '2018-08-12', edition: 6, subject: 'Test subject', summary: 'Test summary', special_collection: false, book_count: 5, is_issued: false, number_hold_req: 0, available_count: 5, libraries_id: 3)
      book.save
      redirect_to students_path
      expect(response).to be_success
      count = book.available_count
      max_allowed = student.max_books

      if count>0
        count=count-1
        issued_books_count = BookRequest.count_by_sql(['select count(*) from book_request where students_id = ?', student.id])

        if ((issued_books_count+1) <= max_allowed)
          is_approved_1 = true
          if(book.special_collection == true)
            is_approved_1 = false
          end
          req = BookRequest.find_by_sql(["select * from book_request where students_id = ? AND books_id = ?",student.id, book.id])
          if req.empty?
            query = "INSERT INTO book_request (date,is_special,is_approved,books_id, students_id, hold) VALUES
                                                ('#{Date.today}','#{book.special_collection}','#{is_approved_1}','#{book.id.to_i}','#{student.id}','#{false}')"
            # BookRequest.connection.execute(query)
            # book.update_attribute(:available_count, count)
            if(is_approved_1 == true)
              borrow_history = BorrowHistory.new(:date => Date.today, :is_special => book.special_collection, :books_id => book.id, :students_id => student.id, :status => "Book Checked Out")
              borrow_history.save
            end
            redirect_to requests_path
          else
            redirect_to root_path
          end
        end
      end
    end
  end

end