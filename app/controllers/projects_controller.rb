# frozen_string_literal: true

# project controller
class ProjectsController < ApplicationController
  before_action :set_project, only: %i[edit update show destroy]

  def index
    @projects = current_user.projects.page(params[:page]).per(6)
  end

  def new
    @project = Project.new
  end

  def edit
    authorize @project
  end

  def create
    @project = current_user.projects.create(project_params)
    if @project.save
      redirect_to @project, flash: { notice: 'Project Created Successfully' }
    else
      render new_project_path, flash: { alert: 'Something went wrong!' }
    end
  end

  def destroy
    authorize @project
    @project.users.clear
    if @project.destroy
      redirect_to projects_path, flash: { notice: 'Project Deleted Successfully' }
    else
      redirect_to @project, flash: { alert: 'Something went wrong' }
    end
  end

  def show
    authorize @project
    @bugs = @project.bugs
    @bugs = @bugs.where('lower(title) LIKE lower(?) ', "%#{params[:name_filter]}%")
    case params[:filter_by]
    when 'New'
      @bugs = @project.bugs.New
    when 'started'
      @bugs = @project.bugs.started
    when 'completed'
      @bugs = @project.bugs.completed
    end
  end

  def update
    authorize @project
    if @project.update(project_params)
      redirect_to @project, flash: { notice: 'Project Updated Successfully' }
    else
      render edit_project_path
    end
  end

  private

  def authorization
    authorize @project
  end

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description, user_ids: [])
  end
end
