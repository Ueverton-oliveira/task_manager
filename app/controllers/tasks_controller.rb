class TasksController < ApplicationController
  before_action :require_login
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.all
    # @tasks = current_user.tasks

    @pending_tasks = @tasks.where(status: 'pending')
    @in_progress_tasks = @tasks.where(status: 'in_progress')
    @review_tasks = @tasks.where(status: 'review')
    @done_tasks = @tasks.where(status: 'done')

  end

  def show; end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      NotificationService.send_notification(@task, 'created')
      WebScrapingService.scrape(@task.url) if @task.url.present?

      redirect_to tasks_path, notice: 'Task criada com sucesso!'
    else
      render :new
    end
  end

  def edit; end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      NotificationService.send_notification(@task, 'updated')
      redirect_to tasks_path, notice: 'Task updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    NotificationService.send_notification(@task, 'deleted')
    redirect_to tasks_path, notice: 'Task deleted successfully.'
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :status, :url, :description, :task_type)
  end

  def require_login
    unless current_user
      flash[:alert] = "Você precisa estar logado para acessar esta página."
      redirect_to login_path
    end
  end

  def current_user
    session[:auth_token]  # Retorna o token de autenticação da sessão
  end

end
