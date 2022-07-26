class ProjectsController < ApplicationController

  def index
    if current_user.manager? || current_user.qa?
      @projects = Project.all
      authorize @projects
    else
      @projects = Project.all.where(dev_id: current_user.id)
      authorize @projects
    end
  end

  def new
    @project = Project.new
    authorize @project
  end

  def edit
    @project = Project.find(params[:id])
    authorize @project
  end

  def create
    @project = current_user.projects.create(project_params)
    authorize @project
    # @project.update!(dev_id: params[:dev_id])

    if @project.save
      redirect_to @project, notice: 'Post Created Successfully'
    else
      render new_project_path
    end
  end

  def destroy
    @project = Project.find(params[:id])
    authorize @project
    @project.users.clear
    @project.destroy

    redirect_to user_session_path, notice: 'Post Deleted Successfully'
  end

  def show
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    authorize @project
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
