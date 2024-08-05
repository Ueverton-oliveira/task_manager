# spec/controllers/tasks_controller_spec.rb

require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:user) { create(:user) }
  let(:valid_token) { 'valid_token' }

  before do
    allow(AuthenticationService).to receive(:validate_token).and_return(auth_service)
    request.headers['Authorization'] = "Bearer #{valid_token}"
  end

  describe "GET #index" do
    let(:auth_service) { class_double("AuthenticationService", current_user: user).as_stubbed_const }

    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    let(:task) { create(:task, user: user) }
    let(:auth_service) { class_double("AuthenticationService", current_user: user).as_stubbed_const }

    it "returns a success response" do
      get :show, params: { id: task.id }
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    let(:auth_service) { class_double("AuthenticationService", current_user: user).as_stubbed_const }

    it "returns a success response" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    let(:auth_service) { class_double("AuthenticationService", current_user: user).as_stubbed_const }

    context "with valid params" do
      it "creates a new task" do
        expect {
          post :create, params: { task: attributes_for(:task) }
        }.to change(Task, :count).by(1)
      end

      it "redirects to tasks_path with notice" do
        post :create, params: { task: attributes_for(:task) }
        expect(response).to redirect_to(tasks_path)
        expect(flash[:notice]).to eq('Task created successfully.')
      end
    end

    context "with invalid params" do
      it "renders the new template again" do
        post :create, params: { task: { name: nil } }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    let(:task) { create(:task, user: user) }
    let(:auth_service) { class_double("AuthenticationService", current_user: user).as_stubbed_const }

    it "returns a success response" do
      get :edit, params: { id: task.id }
      expect(response).to be_successful
    end
  end

  describe "PATCH #update" do
    let(:task) { create(:task, user: user) }
    let(:auth_service) { class_double("AuthenticationService", current_user: user).as_stubbed_const }

    context "with valid params" do
      it "updates the requested task" do
        patch :update, params: { id: task.id, task: { name: "Updated Task" } }
        task.reload
        expect(task.name).to eq("Updated Task")
      end

      it "redirects to tasks_path with notice" do
        patch :update, params: { id: task.id, task: { name: "Updated Task" } }
        expect(response).to redirect_to(tasks_path)
        expect(flash[:notice]).to eq('Task updated successfully.')
      end
    end

    context "with invalid params" do
      it "renders the edit template again" do
        patch :update, params: { id: task.id, task: { name: nil } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:task) { create(:task, user: user) }
    let(:auth_service) { class_double("AuthenticationService", current_user: user).as_stubbed_const }

    it "destroys the requested task" do
      expect {
        delete :destroy, params: { id: task.id }
      }.to change(Task, :count).by(-1)
    end

    it "redirects to tasks_path with notice" do
      delete :destroy, params: { id: task.id }
      expect(response).to redirect_to(tasks_path)
      expect(flash[:notice]).to eq('Task deleted successfully.')
    end
  end

  describe "#authenticate_user!" do
    context "when authenticated" do
      let(:auth_service) { class_double("AuthenticationService", current_user: user).as_stubbed_const }

      it "sets @current_user" do
        get :index
        expect(assigns(:current_user)).to eq(user)
      end
    end

    context "when not authenticated" do
      let(:auth_service) { nil }

      it "returns unauthorized" do
        allow(AuthenticationService).to receive(:validate_token).with(nil).and_return(nil)
        get :index
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
