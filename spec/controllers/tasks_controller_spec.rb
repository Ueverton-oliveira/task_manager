require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:user) { create(:user) }
  let(:task) { create(:task) }

  before do
    session[:user_id] = user.id
  end

  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    it "creates a new task" do
      expect {
        post :create, params: { task: attributes_for(:task) }
      }.to change(Task, :count).by(1)
    end
  end

  describe "PATCH #update" do
    it "updates the task" do
      patch :update, params: { id: task.id, task: { name: 'Updated Task' } }
      task.reload
      expect(task.name).to eq('Updated Task')
    end
  end

  describe "DELETE #destroy" do
    it "deletes the task" do
      task
      expect {
        delete :destroy, params: { id: task.id }
      }.to change(Task, :count).by(-1)
    end
  end
end
