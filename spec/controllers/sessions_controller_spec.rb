require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { create(:user) }

  describe "GET #new" do
    it "returns a successful response" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    it "logs in the user with correct credentials" do
      post :create, params: { email: user.email, password: 'password' }
      expect(session[:user_id]).to eq(user.id)
      expect(response).to redirect_to(tasks_path)
    end

    it "renders new template with incorrect credentials" do
      post :create, params: { email: user.email, password: 'wrong_password' }
      expect(response).to render_template(:new)
    end
  end

  describe "DELETE #destroy" do
    before do
      # Simula o login do usuário antes de testar o logout
      session[:user_id] = user.id
    end

    it "logs out the user" do
      delete :destroy
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(root_path)
    end
  end
end
