require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:user) { create(:user) }
  let(:valid_attributes) { { title: 'Test Task', status: 'pending', url: 'http://example.com' } }
  let(:invalid_attributes) { { title: nil, status: 'pending', url: 'http://example.com' } }

  before do
    request.headers['Authorization'] = "Bearer #{user.generate_jwt}"
  end

  describe 'GET #index' do
    it 'returns a success response' do
      task = Task.create! valid_attributes
      get :index, params: {}
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new Task' do
        expect {
          post :create, params: { task: valid_attributes }
        }.to change(Task, :count).by(1)
      end

      it 'returns a success response' do
        post :create, params: { task: valid_attributes }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      it 'returns an unprocessable entity response' do
        post :create, params: { task: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
