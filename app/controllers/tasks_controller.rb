class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    tasks = Task.all
    @tasks = current_user.tasks

    @pending_tasks = @tasks.where(status: 'pending').order(created_at: :desc)
    @in_progress_tasks = @tasks.where(status: 'in_progress').order(created_at: :desc)
    @review_tasks = @tasks.where(status: 'failed').order(created_at: :desc)
    @done_tasks = @tasks.where(status: 'completed').order(created_at: :desc)

  end

  def show; end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.user = current_user

    if @task.save
      NotificationService.new(@task).send_notification
      WebScrapingService.new((@task.url)).scrape if @task.url.present?

      redirect_to tasks_path, notice: 'Task criada com sucesso!'
    else
      render :new
    end
  end

  def edit; end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      NotificationService.new(@task).send_notification
      redirect_to tasks_path, notice: 'Task updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_path, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :status, :url, :description, :task_type)
  end
end
