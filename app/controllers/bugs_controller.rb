# frozen_string_literal: true

# bugs controller
class BugsController < ApplicationController
  before_action :set_project, only: %i[create destroy]
  before_action :authorization, only: %i[create destroy]

  def create
    @bug = @project.bugs.create(bug_params)
    authorize @bug
    if @bug.save
      redirect_to project_path(@project)
    else
      redirect_to project_path(@project),
                  flash: { alert: 'Title (minimum 10), Deadline, Type and Status is required.' }
    end
  end

  def edit
    @bug = Bug.find(params[:id])
    authorize @bug
    status_completed(@bug)
    status_started(@bug)
  end

  private

  def bug_params
    params.require(:bug).permit(:title, :deadline, :bug_type, :bug_status, :project_id, :dev_id, :avatar)
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  def authorization
    authorize Bug
  end

  def status_completed(bug)

    bug.dev_id = current_user.id


    if bug.started?
      if bug.feature?
        bug.completed!
      else
        bug.resolved!
      end
      redirect_back fallback_location: root_path, flash: { notice: 'Status Updated Successfully.' } if bug.save
    end
  end

  def status_started(bug)
    if bug.New?
      bug.started!
      if bug.save
        redirect_back fallback_location: root_path, flash: { notice: 'Status Updated Successfully.' }
      else
        redirect_to :root
      end
    end
  end
end
