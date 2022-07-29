class BugsController < ApplicationController
  before_action :project_load, only: [:create, :destroy]

  def create

    @bug = @project.bugs.create(bug_params)
    if @bug.save
      redirect_to project_path(@project)
    else
      redirect_to project_path(@project), flash: {alert: 'Could not Create bug. Title, Deadline, Type and Status is required. Title Length should be 10 characters.'}
    end
  end

  def update

  end

  def destroy
    @bug = @project.bugs.find(params[:id])
    @bug.destroy
    redirect_to project_path(@project), flash: {notice: 'Bug Deleted Successfully.'}
  end

  def insert_id
    @bug = Bug.find(params[:id])
    @bug.dev_id = current_user.id
    @bug.bug_status = 1
    @bug.save
    redirect_back fallback_location: root_path

  end

  def bug_resolved
    @bug = Bug.find(params[:id])
    @bug.bug_status = 2
    @bug.save
    redirect_back fallback_location: root_path

  end

  private
  def bug_params
    params.require(:bug).permit!
  end

  private
  def project_load
   @project = Project.find(params[:project_id])
  end

end
