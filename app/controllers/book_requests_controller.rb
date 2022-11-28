class BookRequestsController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  def index
    # @br = BookRequest.all
    @br = BookRequest.all.where(hold: false)
    @book_dict = {}
    @books = Book.all

    @student_dict = {}
    @stud_fines={}
    @individual_fines={}
    @students = Student.all
    @books.each do |book|
      @book_dict[book.id] = book.title
    end
    @students.each do |student|
      @stud_fines[student.id]=0
      @student_dict[student.id]=student.email
    end


    @br.each do |request|
      @book = Book.find(request[:books_id])
      @libr = Library.find(@book[:libraries_id])
      @get_rate = @libr[:fines]
      # @stud_fines[:]
      # @stud =
      # calculate the fine of each book.
      @late_by = (Date.today.mjd-(request[:date].mjd+@libr[:max_days]))
      if(@late_by>0)
        @fined = @late_by*@get_rate
      else
        @fined = 0
      end
      @individual_fines[request.id] = @fined
      @stud_fines[request[:students_id]] += @fined
    end

    @students.each do |student|
      student.update(fines:@stud_fines[student.id])
    end

  end
  def show
    @book = Book.where(params[:id])
  end
  def create
  end
  def edit
  end
  def update
  end
  def destroy
    # @book_request.destroy
    # respond_to do |format|
    #   format.html { redirect_to requests_path, notice: 'Book was successfully returned.' }
    #   format.json { head :no_content }
    # end
  end
  def returns
    # @book = Book.find(params[:id])
    # @student = Student.find_by_email(current_user.email)
    # @book_request = BookRequest.find_by_sql(["select * from book_request where students_id = ? AND books_id = ?",@student.id,@book.id])
    @book_request = BookRequest.find(params[:id])
    @book = Book.find(@book_request[:books_id])
    @student = Student.find(@book_request[:students_id])
    @libr = Library.find(@book[:libraries_id])
    @get_rate = @libr[:fines]
    if @book_request.nil?

    else
      @late_by = (Date.today.mjd-(@book_request[:date].mjd+@libr[:max_days]))
      if(@late_by>0)
        @fined = @late_by*@get_rate
      else
        @fined = 0
      end
        @stud_fines = @student[:fines] - @fined
        @student.update(fines:@stud_fines)
        @book_request.destroy
        @book.update_attribute(:available_count, @book[:available_count]+1)
        @borrow_history = BorrowHistory.new(:date => Date.today, :is_special => @book.special_collection, :books_id => @book.id, :students_id => @student.id, :status => "Returned")
        @borrow_history.save
        @book_hold_req = BookRequest.find_by_sql(["select * from book_request where books_id = ? and hold = ?",@book.id,true])


        if !(@book_hold_req[0].nil?)
          if(@book_hold_req[0][:is_special] == true)
            @book_hold_req[0].update_attribute(:hold, "false")
            @book.update_attribute(:available_count, @book[:available_count]-1)
            redirect_to(root_path, notice: @book_hold_req[0][:books_id].to_s+" has been issued to other user, approval request sent to librarian") and return
          else
            @book_hold_req[0].update_attribute(:hold, "true")
            @book_hold_req[0].update_attribute(:is_approved, "true")
            @book.update_attribute(:available_count, @book[:available_count]-1)

            @student_1 = Student.find(@book_hold_req[0][:student_id])
            @borrow_history = BorrowHistory.new(:date => Date.today, :is_special => @book.special_collection, :books_id => @book.id, :students_id => @student.id, :status => "Checked Out")
            @borrow_history.save

            redirect_to(root_path, notice: @book_hold_req[0][:books_id].to_s+" has been issued to other user") and return


          end
        end
        respond_to do |format|
          format.html { redirect_to requests_path, notice: 'Book was successfully returned.' }
          format.json { head :no_content }




      end

  end
  end

  def hold_requests
    @student = Student.find_by_email(current_user.email)
    @book_request = BookRequest.find_by_sql(["select * from book_request where students_id = ? and hold = ?",@student.id,true])
    @book_request_1 = BookRequest.find_by_sql(["select * from book_request where students_id = ? and is_approved = ? and hold = ?",@student.id,false,false])

  end

  def delete_hold_request
    @book_request = BookRequest.find(params[:id])
    if(@book_request.hold==false)
      @book = Book.find(@book_request[:books_id])
      @book.update({available_count:@book[:available_count]+1})
    end
    @book_request.delete
  end

end
