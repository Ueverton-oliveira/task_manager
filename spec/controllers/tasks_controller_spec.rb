require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:user) { create(:user) }
  let(:token) { "valid_token" }
  let!(:task) { create(:task, user: user, status: 'pending') }
  let(:web_scraping_service) { instance_double(WebScrapingService) }


  before do
    allow(AuthenticationService).to receive(:validate_token).with(token).and_return(true)
    allow(AuthenticationService).to receive(:fetch_user_from_token).with(token).and_return(user)
    request.headers['Authorization'] = "Bearer #{token}"
    allow_any_instance_of(NotificationService).to receive(:send_notification)
    allow(WebScrapingService).to receive(:new).and_return(web_scraping_service)
    allow(web_scraping_service).to receive(:scrape)
  end


  describe 'GET #index' do
    it 'assigns tasks and grouped tasks' do
      get :index
      expect(assigns(:tasks)).to eq([task])
      expect(assigns(:pending_tasks)).to eq([task])
      expect(assigns(:in_progress_tasks)).to eq([])
      expect(assigns(:review_tasks)).to eq([])
      expect(assigns(:done_tasks)).to eq([])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested task' do
      get :show, params: { id: task.id }
      expect(assigns(:task)).to eq(task)
    end
  end

  describe 'GET #new' do
    it 'assigns a new task' do
      get :new
      expect(assigns(:task)).to be_a_new(Task)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new task and redirects to tasks path' do
        expect {
          post :create, params: { task: attributes_for(:task) }
        }.to change(Task, :count).by(1)
        expect(response).to redirect_to(tasks_path)
        expect(flash[:notice]).to eq('Task criada com sucesso!')
      end

      it 'calls WebScrapingService' do
        expect(WebScrapingService).to receive(:new).and_return(web_scraping_service)
        expect(web_scraping_service).to receive(:scrape)

        post :create, params: { task: attributes_for(:task) }
        expect(response).to redirect_to(tasks_path)
      end

      it 'does not create a new task and does not call WebScrapingService' do
        expect(WebScrapingService).not_to receive(:new)
        expect(web_scraping_service).not_to receive(:scrape)

        post :create, params: { task: attributes_for(:task, name: nil) }
        expect(response).to render_template(:new)
      end
    end

    context 'with invalid attributes' do
      it 'renders the new template' do
        post :create, params: { task: attributes_for(:task, name: nil) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested task' do
      get :edit, params: { id: task.id }
      expect(assigns(:task)).to eq(task)
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the task and redirects to tasks path' do
        patch :update, params: { id: task.id, task: { name: 'Updated Task' } }
        task.reload
        expect(task.name).to eq('Updated Task')
        expect(response).to redirect_to(tasks_path)
        expect(flash[:notice]).to eq('Task updated successfully.')
      end
    end

    context 'with invalid attributes' do
      it 'renders the edit template' do
        patch :update, params: { id: task.id, task: { name: nil } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the task and redirects to tasks path' do
      task_to_destroy = create(:task, user: user)
      expect {
        delete :destroy, params: { id: task_to_destroy.id }
      }.to change(Task, :count).by(-1)
      expect(response).to redirect_to(tasks_path)
      expect(flash[:notice]).to eq('Task was successfully destroyed.')
    end
  end
end
