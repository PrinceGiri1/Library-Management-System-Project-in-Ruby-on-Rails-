class AdminsController < ApplicationController
  before_action :set_admin, only: [:show, :edit, :update, :destroy]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /admins
  # GET /admins.json
  def index
    authorize Admin
    @admins = User.find_by_sql(["select * from users where role = ?",2])
  end

  # GET /admins/1
  # GET /admins/1.json
  def show
  # authorize Admin
  end

  # GET /admins/new
  def new
    @admin = Admin.new
    authorize Admin
  end

  # GET /admins/1/edit
  def edit
    authorize Admin
  end

  # POST /admins
  # POST /admins.json
  def create
    authorize Admin
    @admin = Admin.new(admin_params)

    respond_to do |format|
      if @admin.save
        format.html { redirect_to @admin, notice: 'Admin was successfully created.' }
        format.json { render :show, status: :created, location: @admin }
      else
        format.html { render :new }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admins/1
  # PATCH/PUT /admins/1.json
  def update
    authorize Admin
    respond_to do |format|
      if @admin.update(admin_params)
        format.html { redirect_to @admin, notice: 'Admin was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin }
      else
        format.html { render :edit }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end

  end

  # DELETE /admins/1
  # DELETE /admins/1.json
  def destroy
    authorize Admin
    @admin.destroy
    respond_to do |format|
      format.html { redirect_to admins_url, notice: 'Admin was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def librarian_requests
    # @libras = Librarian.all;
    @lib = Librarian.find_by_sql(["select * from librarians where approved = ?", false])
  end

  def approve_librarian
    @libras = Librarian.find_by_sql(["select * from librarians where id = ?",params[:format]])
    @libras.each do |lib|
      if not lib.nil?
        user_params = {:email=>lib.email, :password=>lib.password, :password_confirmation=>lib.password, :libraries_id=>lib.libraries_id, :role=>1}
        @user = User.find_by_email(user_params[:email])
        if(@user.nil?)
        @user = User.new(user_params)
        # @user = User.update([{:email => @lib.email, :password=> @lib.password, :password_confirmation=> @lib.password, :libraries_id=> @lib.libraries_id}])
          if @user.save
            lib.update({:approved=>true})
            @lib2 = Librarian.find_by_email(lib.email)
            redirect_to(:admins, notice: 'Successfully approved Librarian account.')
          else
            redirect_to(:admins, notice: "Unable to approve request.")
          end
        else
          lib.update({:approved=>true})
          redirect_to(:admins, notice: "Librarian already authorised. Deleting request.")
        end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin
      @admin = Admin.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_params
      params.require(:admin).permit(:email, :name, :password)
    end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
end
