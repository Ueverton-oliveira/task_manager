class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    @tasks = current_user.tasks
    render json: @tasks
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      notify_create_or_update
      render json: @task, status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :status, :url)
  end

  def notify_create_or_update
    HTTParty.post('http://notification_service/notify',
                  body: { task: @task, user: current_user }.to_json,
                  headers: { 'Content-Type' => 'application/json' })
  end
end
