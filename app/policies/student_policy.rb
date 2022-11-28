class StudentPolicy < ApplicationPolicy
  attr_reader :current_user, :model

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(user: user)
        scope.all
      end
    end
  end

  def initialize(current_user, model)
    @current_user = current_user
    @user = model
  end

  def index?
    current_user.user? or current_user.admin?
  end

  def show?
    current_user.admin? or current_user.user?
  end

  def update?
    current_user.admin? or current_user.user?
  end

  def new?
    current_user.admin?
  end

  def create?
    current_user.admin?
  end

  def destroy?
    current_user.admin?
  end
end