class LibrariansController < ApplicationController
  before_action :set_librarian, only: [:show, :edit, :update, :destroy]
  # skip_before_action :verify_authenticity_token
  after_action :verify_authorized
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  helper_method :approve_book_request

  # GET /librarians
  # GET /librarians.json
  def index
    # @user = Librarian.find(params[:id])
    # unless current_user.librarian?
    #   unless @user == current_user
    #     redirect_to :back, :alert => "Access denied!"
    #   end
    # end
    # @users = Librarian.all
    # @my_models = policy_Scope(MyModel)
    @librarians = policy_scope(Librarian)
    @librarians = Librarian.all

    @library_dict = {}
    @libs = Library.all

    @libs.each do |l|
      @library_dict[l.id] = l.name
    end

    authorize Librarian
  end

  # GET /librarians/1
  # GET /librarians/1.json
  def show
    # @user = Librarian.find(params[:id])
    # unless current_user.librarian?
    #   unless @user == current_user
    #     redirect_to :back, :alert => "Access denied!"
    #   end
    # end
    # @users = Librarian.all
    #
    @library_dict = {}
    @libs = Library.all

    @libs.each do |l|
      @library_dict[l.id] = l.name
    end

    authorize Librarian
    # @user = User.find(params[:id])
    # unless current_user.librarian?
    #   unless @user == current_user
    #     redirect_to user_homepage, :alert => "Access denied!"
    #   end
    # end

    if(current_user.librarian?)
      @lib = Librarian.find_by_email(current_user.email)
      @lib2 = Librarian.find(params[:id])
      if(@lib.id!=@lib2[:id])
        flash[:alert] = "You are not authorized to perform this action."
        redirect_to(request.referrer || root_path)
      end
    end

  end

  # GET /librarians/new
  def new
    @librarian = Librarian.new
    authorize Librarian
  end

  # GET /librarians/1/edit
  def edit
    authorize Librarian
    if(current_user.librarian?)
      @lib = Librarian.find_by_email(current_user.email)
      @lib2 = Librarian.find(params[:id])
      if(@lib.id!=@lib2[:id])
        flash[:alert] = "You are not authorized to perform this action."
        redirect_to(request.referrer || root_path)
      end
    end
  end

  # POST /librarians
  # POST /librarians.json
  def create
    authorize Librarian
    @librarian = Librarian.new(librarian_params)
    @user = User.new({email:@librarian.email,password:@librarian.password,password_confirmation:@librarian.password})

    # create user entry here
    respond_to do |format|
      if @librarian.save
        @librarian.update(approved:true)
        @user.save
        format.html { redirect_to user_homepage_path, notice: 'Request sent to Admin was authorisation.' }
        format.json { render :show, status: :created, location: user_homepage_path }
      else
        format.html { render :new }
        format.json { render json: @librarian.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /librarians/1
  # PATCH/PUT /librarians/1.json
  def update
    authorize Librarian
    @user = User.find_by_email(@librarian.email)
    respond_to do |format|
      if @librarian.update(librarian_params)
        @user.update({email:@librarian.email})
        format.html { redirect_to librarians_url, notice: 'Librarian was successfully updated.' }
        format.json { render :show, status: :ok, location: @librarian }
      else
        format.html { render :edit }
        format.json { render json: @librarian.errors, status: :unprocessable_entity }
      end
    end
  end

  def list_special_book_request
    authorize Librarian
    query = "select * from book_request"
    #@book_request = BookRequest.find(query)
    @book_request = BookRequest.all.where(is_approved: 'false', hold: 'false')
  end

  def approve_book_request
    authorize Librarian
    @book_request = BookRequest.find(params[:id])
   # query = "update book_request"
    @book_request.update_attribute(:is_approved,"true")

    @book = Book.find(@book_request[:books_id])
    @student = Student.find(@book_request[:students_id])
    @borrow_history = BorrowHistory.new(:date => Date.today, :is_special => @book.special_collection, :books_id => @book.id, :students_id => @student.id, :status => "Approved by Librarian - Book Checked Out")
    @borrow_history.save
      # query_1 = "INSERT INTO borrow_histories (date, is_special, books_id, students_id, status) VALUES
    #                                                    ('#{Date.today}','#{@book.special_collection}','#{@book.id}','#{@student.id}','#{"Checked Out"}')"
    # BorrowHistory.connection.execute(query_1)
  end

  # DELETE /librarians/1
  # DELETE /librarians/1.json
  def destroy
    authorize Librarian
    # @librarian.destroy
    respond_to do |format|
      if @librarian.destroy
        format.html { redirect_to librarians_url, notice: 'Librarian was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html {redirect_to librarian_url, alert: 'Librarian was not successfully destroyed.'}
      end
    end
  end

  def copy_data
    if self.librarian?


      @user = User.find(self.id)
      if Librarian.find_by_email(self.email).nil?
        @lib = Librarian.new(email: self.email, password: self.encrypted_password, libraries_id: 1)
        @lib.save
        #   flash[:success] = "Successfully saved data to Librarian model"
        # redirect_to librarians_path

        # else
        #   flash[:error] = "Could not create record"
        # end
      end

      # @user = Librarian.find(self.id)
      # if (nil == @user)
      #   @lib = Librarian.create(email: self.email, name:self.email, password: self.encrypted_password, users_id: self.id)
      #   @lib.save
      # else
      #   @lib = Librarian.create(email: self.email, name:self.email, password: self.encrypted_password, users_id: self.id)
      #   @lib.save
      # end
      #
    elsif self.user?
      # @user = User.find(self.id)
      if Student.find_by_email(self.email).nil?
        @stud = Student.new(email: self.email, password: self.encrypted_password)
        @stud.save
        #   flash[:success] = "Successfully saved data to Student model"
        # redirect_to students_path
        # else
        #   flash[:error] = "Could not create record"
        # end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_librarian
      @librarian = Librarian.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def librarian_params
      params.require(:librarian).permit(:email, :name, :password, :libraries_id)
    end

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to(request.referrer || root_path)
    end
end
