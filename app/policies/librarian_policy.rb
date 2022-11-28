class LibrarianPolicy < ApplicationPolicy
  attr_reader :current_user, :model


  # class Scope < Scope
  #   def resolve
  #     if user.admin? or user.librarian?
  #       scope.all
  #     else
  #       raise Pundit::NotAuthorizedError, 'not allowed to view this action'
  #       #redirect_back :alert => "Access denied!"
  #       # raise :alert => "Access denied!"
  #
  #     end
  #   end
  # end

  def initialize(current_user, model)
    @current_user = current_user
    @user = model
  end

  def index?
    # @user = Librarians.find(params[:id])
    # redirect_to librarians unless current_user == @user
    current_user.librarian? or current_user.admin?
    # logger.info "here here ",current_user.kind_of?
    # or @current_user.admin? or @current_user.user?
  end

  def show?
    current_user.admin? or current_user.librarian?
    # @current_user.librarian? or
    #     @current_user.admin?
    #     @current_user.librarian?
  end

  def update?
    current_user.admin? or current_user.librarian?
  end

  def new?
    current_user.admin? or current_user.librarian?
  end

  def create?
    current_user.admin? or current_user.librarian?
  end

  def edit?
    current_user.admin? or current_user.librarian?
  end

  def destroy?
    return false if current_user == @user
    current_user.admin?
  end


  def list_special_book_request?
    current_user.admin? or current_user.librarian?
  end

  def approve_book_request?
    current_user.admin? or current_user.librarian?
  end
end