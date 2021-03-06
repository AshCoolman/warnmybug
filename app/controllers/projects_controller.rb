class ProjectsController < ApplicationController
  before_action :set_project, only: [:edit, :update, :destroy]

  def index
    @projects = current_user.projects.all
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      @project.users << current_user
      UserPreference.create_default!(current_user.id, @project.environment.id)

      redirect_to project_environment_path(@project, @project.environment)
    else
      render :new
    end
  end

  def update
    if @project.update(project_params)
      respond_with @project
    else
      render :edit
    end
  end

  def destroy
    @project.destroy

    redirect_to projects_url
  end

  private

  def set_project
    @project = current_user.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name)
  end
end
