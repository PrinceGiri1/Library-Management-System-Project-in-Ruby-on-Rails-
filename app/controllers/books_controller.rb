class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  # GET /books
  # GET /books.json
  def index
    @books = if (params[:search_by_title] || params[:search_by_author] || params[:search_by_subject] || params[:search_by_published_before] || params[:search_by_published_after])
               if (params[:search_by_published_before]!="" && params[:search_by_published_after]!="")
                 Book.where('lower(title) LIKE ? and lower(author) LIKE ? and lower(subject) LIKE ? and published > ? and published < ?', "%#{params[:search_by_title].downcase}%","%#{params[:search_by_author].downcase}%","%#{params[:search_by_subject].downcase}%","#{params[:search_by_published_before]}","#{params[:search_by_published_after]}")
               elsif (params[:search_by_published_before]!="")
                 Book.where('lower(title) LIKE ? and lower(author) LIKE ? and lower(subject) LIKE ? and published < ?', "%#{params[:search_by_title].downcase}%","%#{params[:search_by_author].downcase}%","%#{params[:search_by_subject].downcase}%","#{params[:search_by_published_before]}")
               elsif (params[:search_by_published_after]!="")
                 Book.where('lower(title) LIKE ? and lower(author) LIKE ? and lower(subject) LIKE ? and published > ?', "%#{params[:search_by_title].downcase}%","%#{params[:search_by_author].downcase}%","%#{params[:search_by_subject].downcase}%" ,"#{params[:search_by_published_after]}")
               else
                 Book.where('lower(title) LIKE ? and lower(author) LIKE ? and lower(subject) LIKE ?', "%#{params[:search_by_title].downcase}%","%#{params[:search_by_author].downcase}%","%#{params[:search_by_subject].downcase}%")
               end
             else
               Book.all
             end
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
    # @book.image.attach(io: File.open())
  end

  # GET /books/1/edit
  def edit
    authorize Librarian
    if(current_user.librarian?)
      @lib = Librarian.find_by_email(current_user.email)
      @book = Book.find(params[:id])
      if(@book.libraries_id!=@lib[:libraries_id])
        flash[:alert] = "You are not authorized to perform this action."
        redirect_to(request.referrer || root_path)
      end
    end
  end

  # POST /books
  # POST /books.json
  def create
    # render plain: params[:book].inspect

    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        # @book.available_count = book_params[:book_count]
        @book.update_attribute(:available_count,book_params[:book_count])
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end


  def search
    if params[:search].blank?
      redirect_to(root_path, alert: "Empty field!") and return
    else
      @parameter = params[:search].downcase
      @results = Book.all.where("lower(title) LIKE :search", search: @parameter)
      end

  end

  def book_request
    @book = Book.find(params[:id])
    @current_count = @book.available_count
    @student = Student.find_by_email(current_user.email)
    @max_book_allowed = @student.max_books

    if (@current_count > 0)
        @current_count = @current_count-1



        @issued_books_count = BookRequest.count_by_sql(['select count(*) from book_request where
                                                             students_id = ?',@student.id])
          if ((@issued_books_count+1) <= @max_book_allowed)
              @is_approved_1 = true
              if(@book.special_collection == true)
                  @is_approved_1 = false
              end
              @req = BookRequest.find_by_sql(["select * from book_request where students_id = ? AND books_id = ?",@student.id,@book.id])
              if @req.empty?
              query = "INSERT INTO book_request (date,is_special,is_approved,books_id, students_id,hold) VALUES
                                                ('#{Date.today}','#{@book.special_collection}','#{@is_approved_1}','#{@book.id}','#{@student.id}','#{false}')"
              BookRequest.connection.execute(query)
              @book.update_attribute(:available_count, @current_count)
              if(@is_approved_1 == true)
                @borrow_history = BorrowHistory.new(:date => Date.today, :is_special => @book.special_collection, :books_id => @book.id, :students_id => @student.id, :status => "Book Checked Out")
                @borrow_history.save
              end
              redirect_to(requests_path, notice: "List of all books collected.")
              else redirect_to(root_path, alert: "Already requested or collected.");
              end
          else
            redirect_to(root_path, alert: "Maximum allowed books has been reached for your account - "+@max_book_allowed.to_s)
          end

    else
      @req = BookRequest.find_by_sql(["select * from book_request where students_id = ? AND books_id = ?",@student.id,@book.id])
      if @req.empty?
      query = "INSERT INTO book_request (date,is_special,is_approved,books_id, students_id,hold) VALUES
                                                ('#{Date.today}','#{@book.special_collection}','#{false}','#{@book.id}','#{@student.id}','#{true}')"
      BookRequest.connection.execute(query)
      redirect_to(root_path, alert: "Book has been exhausted, and kept on request for Hold.")
      else redirect_to(root_path, alert: "Already placed on hold.");
      end

      end

  end

  def bookmarked
    @book = Book.find(params[:id])
    @user = User.find_by_email(current_user.email) # @student = Student.find_by_email(current_user.email)

    @records = Bookmark.where(books_id: @book.id, users_id: @user.id)

    if @records.blank?
      @bookmark = Bookmark.new(:books_id=>@book.id, :users_id=>@user.id)
      if @bookmark.save
        redirect_to books_path, notice: 'Bookmark created successfully !' and return
      else
        flash[:notice] = 'Database Error !'
      end
    else
      flash[:notice] = 'Bookmark has already been created !'
    end



    # # @records = Bookmark.find_by({:books_id=>@book.id, :users_id=>@user.id})
    # if @records.nil?
    #   @bookmark = Bookmark.new(:books_id=>@book.id, :users_id=>@user.id)
    #   if @bookmark.save
    #     redirect_to books_path, notice: 'Bookmark created successfully !' and return
    #   else
    #     flash[:notice] = 'Database Error !'
    #   end
    # else
    #   if @records.find_by_books_id(params[:id]).nil?
    #     @bookmark = Bookmark.new(:books_id=>@book.id, :users_id=>@user.id)
    #     if @bookmark.save
    #       redirect_to books_path, notice: 'Bookmark created successfully !' and return
    #     else
    #       flash[:notice] = 'Database Error !'
    #     end
    #   end
    # end

    # if @bookmark != nil
    #   if @bookmark.save
    #     redirect_to books_path, notice: 'Bookmark created successfully !' and return
    #   else
    #     flash[:notice] = 'Database Error !'
    #   end
    # else
    #   flash[:notice] = 'Bookmark has already been created !'
    # end


    # if Bookmark.find_by_books_id(params[:id]) == nil
    #
    #   # bookmark_params = {books_id: @book.id, users_id: @user.id}
    #   @bookmark = Bookmark.new(:books_id=>@book.id, :users_id=>@user.id)
    #
    #   if @bookmark.save
    #     redirect_to books_path, notice: 'Bookmark created successfully !'
    #   end
    #
    # else
    #   # render :bookmarked, notice1: 'Bookmark has already been created !'
    #   flash[:notice] = 'Bookmark has already been created !'
    # end


    #
    # respond_to do |format|
    #   if @bookmark.save
    #     format.html { redirect_to bookmarks_path, notice: 'Bookmark created successfully !' }
    #     format.json { render :index, status: :created, location: @book }
    #   else
    #     format.html { render :bookmark }
    #     # format.json { render json: @book.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  helper_method :book_request
  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def add_details

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:title, :isbn, :author, :language, :published, :edition, :subject, :image, :summary, :special_collection, :book_count, :libraries_id, :search)
      # params.fetch(:book, {})
    end
end
