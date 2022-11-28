class HomeController < ApplicationController
	# skip_before_action :authenticate_user!, only: [:show, :index]
  skip_before_action :authenticate_user!, only: [:index]

  def index
  	# redirect_to page2_path
  	# automatically redirect user to his/her homepage if already signed in
  	# Refer: https://stackoverflow.com/a/28596567/6543250
    if user_signed_in?
      # redirect_to user_homepage_path
      if current_user.librarian?
        @lib = Librarian.find_by_email(current_user.email)
        if @lib.name.nil? or @lib.libraries_id.nil?
          @var = @lib.id
          params={:id => @var}
          redirect_to edit_librarian_path(params[:id])
        else
          redirect_to librarians_path
        end
      elsif current_user.user?
        @user = User.find_by_email(current_user.email)
        if @user.provider == 'facebook'
          if Student.find_by_email(current_user.email).blank?
            @stud = Student.new({email:@user.email,education:"DUMMY",university:"DUMMY",max_books:0})
            @stud.save
            redirect_to edit_student_path(@stud[:id]) and return
          end
        end
        @stud = Student.find_by_email(current_user.email)
        if @stud.name.nil? or @stud.university.nil?
          @var = @stud.id
          params={:id=> @var}
          redirect_to edit_student_path(params[:id]) and return
        else
          redirect_to students_path
        end
      else
        redirect_to user_homepage_path
      end
    end
    respond_to do |format|
      format.html
      format.json
    end
  end
end
