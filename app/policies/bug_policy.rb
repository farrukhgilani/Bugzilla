# frozen_string_literal: true

# policy
class BugPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def initialize(user, project)
    super
    @user = user
    @project = project
  end

  def create?
    return true if @user.present? && @user.manager? || @user.qa?
  end

  def destroy?
    return true if @user.present? && @user.manager?
  end

  def edit?
    return true if @user.present? && @user.developer?
  end
end
