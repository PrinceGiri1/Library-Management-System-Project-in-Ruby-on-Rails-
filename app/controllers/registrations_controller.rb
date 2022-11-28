class RegistrationsController < Devise::RegistrationsController


  def create

    if sign_up_params[:role]=='user'
      @stud = Student.find_by_email(sign_up_params[:email])
      if @stud.nil?
        @stud = Student.new(email: sign_up_params[:email], name: params[:user][:student][:name],
                            password: sign_up_params[:password], education: params[:user][:student][:education],
                            university: params[:user][:student][:university], max_books:2, fines: 0)
        if @stud.save
          if(@stud[:education]=="Masters")
            @stud.update({max_books:4})
          elsif (@stud[:education]=="PhD")
            @stud.update({max_books:6})
          else
            @stud.update({max_books:2})
          end
        end
        super and return
        # redirect_to :student and return
      else
        # @stud.update(student_signup_params)
        # format.html { redirect_to students_path, notice: 'Student was successfully created.' }
        # format.json { render :show, status: :created, location: @student }
      end
    elsif sign_up_params[:role]=='librarian'
      @lib = Librarian.find_by_email(sign_up_params[:email])
      if(@lib.nil?)
        @lib = Librarian.new(email: sign_up_params[:email], name: params[:user][:librarian][:name],
                             password: sign_up_params[:password], libraries_id: params[:user][:librarian][:libraries_id],
                             approved: false)
        @lib.save
        redirect_to new_user_session_path, :flash=>{:alert => 'Request has been sent. Pending admin approval.'}
        # format.json { render :show, status: :accepted, location: home_index_path}
      else
        # @lib.update(librarian_signup_parmas)
        # format.html { redirect_to librarians_path, notice: 'Student was successfully created.' }
        # format.json { render :show, status: :created, location: @librarian }
      end
    else
      redirect_to new_user_session_path, :flash =>{:alert =>'Redirected to user homepage.'}
    end
    # end

    # @user = User.find_by_email(current_user.email)
    # # if current_user.librarian?
    # #   @user.update({libraries_id: @lib.libraries_id})
    # # else
    #   if current_user.user?
    #   @user.update({students_id: @stud.user_id})
    # end
    # # if @user.save
    #   format.html { redirect_to @user, notice: 'Student was successfully created.' }
    #   format.json { render :show, status: :created, location: @user }
    #  else
    #   format.html { render :new }
    #   format.json { render json: @user.errors, status: :unprocessable_entity }
    # end
    # end
  end

  private
  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role,
                                 student_attributes: [:email, :name, :password, :education, :university, :max_books],
                                 librarian_attributes: [:email, :name, :password, :libraries_id])
  end
  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
  end

end


# class RegistrationsController < Devise::RegistrationsController
#
#   def create
#
#     # @user = User.new(sign_up_params)
#     # @user.save
#     # respond_to do |format|
#     if sign_up_params[:role]=='user'
#         @stud = Student.find_by_email(sign_up_params[:email])
#         if @stud.nil?
#           @stud = Student.new(email: sign_up_params[:email], name: params[:user][:student][:name],
#                               password: sign_up_params[:password], education: params[:user][:student][:education],
#                               university: params[:user][:student][:university], max_books: params[:user][:student][:max_books])
#           @stud.save
#           super and return
#           redirect_to :student, notice: 'Successfully signed up as Student.'
#         else
#           # @stud.update(student_signup_params)
#           # format.html { redirect_to students_path, notice: 'Student was successfully created.' }
#           # format.json { render :show, status: :created, location: @student }
#         end
#       elsif sign_up_params[:role]=='librarian'
#         @lib = Librarian.find_by_email(sign_up_params[:email])
#         if(@lib.nil?)
#           @lib = Librarian.new(email: sign_up_params[:email], name: params[:user][:librarian][:name],
#                                password: sign_up_params[:password], libraries_id: params[:user][:librarian][:libraries_id],
#                                approved: false)
#           @lib.save
#           format.html {redirect_to new_user_session_path, :flash=>{:alert => 'Request has been sent. Pending admin approval.'}
#           # format.json { render :show, status: :accepted, location: home_index_path}
#         # else
#           # @lib.update(librarian_signup_parmas)
#           # format.html { redirect_to librarians_path, notice: 'Student was successfully created.' }
#           # format.json { render :show, status: :created, location: @librarian }
#         end
#       end
#     # end
#     redirect_to new_user_session_path, :flash=>{:alert => 'Redirected to user homepage.'} and return
#     # @user = User.find_by_email(current_user.email)
#     # # if current_user.librarian?
#     # #   @user.update({libraries_id: @lib.libraries_id})
#     # # else
#     #   if current_user.user?
#     #   @user.update({students_id: @stud.user_id})
#     # end
#     # # if @user.save
#     #   format.html { redirect_to @user, notice: 'Student was successfully created.' }
#     #   format.json { render :show, status: :created, location: @user }
#     #  else
#     #   format.html { render :new }
#     #   format.json { render json: @user.errors, status: :unprocessable_entity }
#     # end
#     # end
#   end
#
#   private
#   def sign_up_params
#     params.require(:user).permit(:name, :email, :password, :password_confirmation, :role,
#                                  student_attributes: [:email, :name, :password, :education, :university, :max_books],
#                                  librarian_attributes: [:email, :name, :password, :libraries_id])
#   end
#   def account_update_params
#     params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
#   end
# end
