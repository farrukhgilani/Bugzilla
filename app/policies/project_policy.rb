# frozen_string_literal: true

# policy
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
    if @user.qa?
      true
    elsif @project.users.include?(user)
      true
    end
  end

  def create?
    return true if @user.present? && @user.manager?
  end

  def show?
    if @user.qa?
      true
    elsif @project.users.include?(user)
      true
    end
  end

  def create?
    return true if @user.present? && @user.manager?
  end

  def edit?
    return true if @user.present? && @project.users.include?(user) && @user.manager?
  end

  def update?
    edit?
  end

  def new?
    return true if @user.present? && @user.manager?
  end

  def destroy?
    return true if @user.present? && @project.users.include?(user) && @user.manager?
  end

  def developer?
    return true if @user.present? && @user.developer?
  end

  def qa?
    return true if @user.present? && @user.qa?
  end

  def manager?
    return true if @user.present? && @user.manager?
  end

  private

  def project
    record
  end
end
