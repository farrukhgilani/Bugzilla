class BugsController < ApplicationController
  def new

  end

  def create
    @project = Project.find(params[:project_id])
    @bug = @project.bugs.create(bug_params)
    redirect_to project_path(@project)
  end

  def show
  end

  def edit
  end

  def update
  end

  def index
  end

  def destroy
    @project = Project.find(params[:project_id])
    @bug = @project.bugs.find(params[:id])
    @bug.destroy
    redirect_to project_path(@project)
  end

  private
  def bug_params
    params.require(:bug).permit!
  end
end
