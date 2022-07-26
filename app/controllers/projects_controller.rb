class ProjectsController < ApplicationController

  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def edit
    @project = Project.find(params[:id])
  end

  def create
    @project = current_user.projects.create(project_params)
    # @project.update!(dev_id: params[:dev_id])

    if @project.save
      redirect_to @project
    else
      render new_project_path
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.users.clear
    @project.destroy
    redirect_to user_session_path
  end

  def show
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    if @project.update(project_params)
      redirect_to @project
    else
      render new_project_path
    end
  end

  private
  def project_params
    params.require(:project).permit(:name, :description, :dev_id )
  end

end
