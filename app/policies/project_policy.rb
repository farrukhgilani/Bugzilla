class ProjectPolicy < ApplicationPolicy
  def resolve
    scope.all
  end

  def initialize(user, project)
    super
    @user = user
    @project = project
  end

  def index?
   true
  end

  def create?
    return true if @user.present? && @user.manager?
  end

  def edit?
    return true if @user.present? && @user.manager?
  end

  def update?
    return true if @user.present? && @user.manager?
  end

  def destroy?
    return true if @user.present? && @user.manager?
  end

  private

    def project
      record
    end
end
