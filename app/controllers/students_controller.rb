class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # GET /students
  # GET /students.json
  def index
    authorize Student
    if User.find_by_email(current_user.email).provider == 'facebook' and Student.find_by_email(current_user.email).education == 'DUMMY'
      redirect_to edit_student_path(Student.find_by_email(current_user.email)), notice: 'Please fill out details first !'
    end

    @students = Student.all
    # authorize Student
  end

  # GET /students/1
  # GET /students/1.json
  def show
    authorize Student
    if(current_user.user?)
      @stud = Student.find_by_email(current_user.email)
      @stud2 = Student.find(params[:id])
      if(@stud.id!=@stud2[:id])
        flash[:alert] = "You are not authorized to perform this action."
        redirect_to(request.referrer || root_path)
      end
    end
  end

  # GET /students/new
  def new
    @student = Student.new
    authorize Student
  end

  # GET /students/1/edit
  def edit
    authorize Student
    if(current_user.user?)
      @stud = Student.find_by_email(current_user.email)
      @stud2 = Student.find(params[:id])
      if(@stud.id!=@stud2[:id])
        flash[:alert] = "You are not authorized to perform this action."
        redirect_to(request.referrer || root_path)
      end
    end
  end

  # POST /students
  # POST /students.json
  def create
    authorize Student
    student_params[:fines]=0
    @student = Student.new(student_params)
    @user = User.new({email:@student.email,password:@student.password,password_confirmation:@student.password})
    respond_to do |format|
      if @student.save
        if(@student[:education]=="Masters")
          @student.update({max_books:4})
        elsif (@student[:education]=="PhD")
           @student.update({max_books:6})
        else
          @student.update({max_books:2})
        end
        @user.save
        format.html { redirect_to @student, notice: 'Student was successfully created.' }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    authorize Student
    @user = User.find_by_email(@student.email)
    # if student_params['education'] == 'Undergraduate'
    #   student_params[:student][:max_books] = 2
    # elsif student_params['education'] == 'Masters'
    #   student_params[:student][:max_books] = 4
    # else
    #   student_params[:student][:max_books] = 6
    # end

    respond_to do |format|
      if @student.update(student_params)
        @user.update({email:@student.email})

        maxbooks_cnt=0
        # update max_books here
        education = @student.education
        if education == 'Undergraduate'
          maxbooks_cnt = 2
        elsif education == 'Masters'
          maxbooks_cnt = 4
        else
          maxbooks_cnt = 6
        end

        # fire update query here
        @student.update(max_books: maxbooks_cnt)

        format.html { redirect_to @student, notice: 'Student was successfully updated.' }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    authorize Student
    @student.destroy
    respond_to do |format|
      format.html { redirect_to students_url, notice: 'Student was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def find_student_id(email)
    return Student.find_by_email(email)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:student).permit(:email, :name, :password, :education, :university, :max_books, :fines)
    end

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to(request.referrer || root_path)
    end
end
