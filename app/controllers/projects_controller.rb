# frozen_string_literal: true

# project controller
class ProjectsController < ApplicationController
  before_action :authorization, only: %i[index new create edit update destroy]
  before_action :project_find, only: %i[edit update show destroy]

  def index
    @projects = if current_user.manager? || current_user.qa?
                  Project.page(params[:page]).per(6)
                else
                  Project.page(params[:page]).per(6).where(dev_id: current_user.id)
                end
  end

  def new
    @project = Project.new
  end

  def edit

  end

  def create
    @project = current_user.projects.create(project_params)
    if @project.save
      redirect_to @project, flash: { notice: 'Post Created Successfully' }
    else
      render new_project_path
    end
  end

  def destroy
    @project.users.clear
    if @project.destroy
      redirect_to projects_path, flash: { notice: 'Post Deleted Successfully' }
    else
      redirect_to @project, flash: { alert: 'Something went wrong' }
    end
  end

  def show
    @bugs = Project.includes(:bugs).where(id: params[:id]).map(&:bugs).flatten
  end

  def update
    if @project.update(project_params)
      redirect_to @project
    else
      render new_project_path
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :description, :dev_id)
  end

  def authorization
    authorize Project
  end

  def project_find
    @project = Project.find(params[:id])
  end
end
