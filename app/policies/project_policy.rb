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
    true
  end

  def show?
    if @user.manager?
      return true if UserProject.where(project_id: @project.id) == @project.user_projects.where(user_id: @user.id)
    elsif @user.developer?
      @project.dev_id.include?(user.id)
    end
  end

  def create?
    return true if @user.present? && @user.manager?
  end

  def edit?
    if UserProject.where(project_id: @project.id) == @project.user_projects.where(user_id: @user.id) && @user.manager?
      true
    end
  end

  def update?
    return true if @user.present? && @user.manager?
  end

  def destroy?
    if UserProject.where(project_id: @project.id) == @project.user_projects.where(user_id: @user.id) && @user.manager?
      true
    end
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
