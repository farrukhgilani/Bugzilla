# frozen_string_literal: true

# project controller
class ProjectsController < ApplicationController
  #before_action :authorization, only: %i[index new create edit update]
  before_action :set_project, only: %i[edit update show destroy]

  def index

    @projects = if current_user.manager?
                  current_user.projects.page(params[:page]).per(6)
                elsif current_user.qa?
                  Project.page(params[:page]).per(6)
                else
                  puts :dev_id
                  Project.page(params[:page]).per(6).where(":dev_id = ANY(dev_id)", dev_id: current_user.id)
                end
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
      redirect_to @project, flash: { notice: 'Post Created Successfully' }
    else
      render new_project_path , flash: { notice: 'Something went wrong!' }
    end
  end

  def destroy
    authorize @project
    @project.users.clear
    if @project.destroy
      redirect_to projects_path, flash: { notice: 'Post Deleted Successfully' }
    else
      redirect_to @project, flash: { alert: 'Something went wrong' }
    end
  end

  def show
    if current_user.manager? || current_user.developer?
      authorize @project
    end
    @bugs = @project.bugs
    if params[:new]
      @bugs = @project.bugs.New
    elsif params[:started]
      @bugs = @project.bugs.where(bug.New)
    elsif params[:completed]
      @bugs = Bug.all
    end
  end

  def update
    authorize @project
    if @project.update(project_params)
      redirect_to @project
    else
      render new_project_path
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
      params.require(:project).permit(:name, :description, dev_id: [])
    end
end
