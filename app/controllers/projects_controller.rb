# frozen_string_literal: true

# project controller
class ProjectsController < ApplicationController
  before_action :set_project, only: %i[edit update show destroy]
  before_action :authorization, only: %i[edit show destroy update]

  def index
    if current_user.qa?
      @projects = Project.page(params[:page]).per(6)
    else
      @projects = current_user.projects.page(params[:page]).per(6)
    end

  end

  def new
    @project = Project.new
    authorize @project
  end

  def edit; end

  def create
    @project = current_user.projects.create(project_params)
    authorize @project

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
    @bugs = @project.bugs
    @bugs = @bugs.where('lower(title) LIKE lower(?) ', "%#{params[:name_filter]}%")
    # byebug
    case params[:filter_by]
      when 'New'
        @bugs = @project.bugs.New
      when 'started'
        @bugs = @project.bugs.started
      when 'completed'
        @bugs = @project.bugs.completed
      when 'resolved'
        @bugs = @project.bugs.resolved
    end
  end

  def update
    #params[:project][:user_ids] << current_user.id
    if @project.update(project_params)
      redirect_to @project, flash: { notice: 'Project Updated Successfully' }
    else
      redirect_to edit_project_path, flash: { alert: 'Something Went Wrong!' }
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
