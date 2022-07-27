class BugsController < ApplicationController

  def create
    @project = Project.find(params[:project_id])
    @bug = @project.bugs.create(bug_params)
    redirect_to project_path(@project)
  end

  def edit
  end

  def update
  end

  def destroy
    @project = Project.find(params[:project_id])
    @bug = @project.bugs.find(params[:id])
    @bug.destroy
    redirect_to project_path(@project)
  end

  def insert_id
    @bug = Bug.find(params[:id])
    @bug.dev_id = current_user.id
    @bug.save
  end
  def bug_resolved
    @bug = Bug.find(params[:id])
    @bug.bug_status = 2
    @bug.save
  end

  private
  def bug_params
    params.require(:bug).permit!
  end
end
