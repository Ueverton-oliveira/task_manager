require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'GET #new' do
    it 'renders the new registration template' do
      get :new
      expect(response).to render_template('sessions/new')
    end
  end

  describe 'POST #create' do
    context 'with valid registration' do
      it 'redirects to login path with notice' do
        allow(AuthenticationService).to receive(:register).and_return(success: true)
        post :create, params: { email: 'test@example.com', password: 'password', name: 'Test User' }
        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to eq('Usuário registrado com sucesso! Por favor, faça login.')
      end
    end

    context 'with invalid registration' do
      it 'renders new with flash alert' do
        allow(AuthenticationService).to receive(:register).and_return(success: false, errors: ['Email já está em uso'])
        post :create, params: { email: 'test@example.com', password: 'password', name: 'Test User' }
        expect(response).to render_template('sessions/new')
        expect(flash.now[:alert]).to eq('Email já está em uso')
      end
    end
  end

  describe 'GET #login' do
    it 'renders the login template' do
      get :login
      expect(response).to render_template('sessions/login')
    end
  end

  describe 'POST #authenticate' do
    context 'with valid credentials' do
      it 'creates a session and redirects to root path' do
        allow(AuthenticationService).to receive(:login).and_return(success: true, token: 'valid_token')
        post :authenticate, params: { email: 'test@example.com', password: 'password' }
        expect(session[:auth_token]).to eq('valid_token')
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Login realizado com sucesso!')
      end
    end

    context 'with invalid credentials' do
      it 'sets flash alert and redirects back' do
        allow(AuthenticationService).to receive(:login).and_return(success: false, errors: ['Credenciais inválidas'])
        post :authenticate, params: { email: 'test@example.com', password: 'wrong_password' }
        expect(session[:auth_token]).to be_nil
        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq('Credenciais inválidas')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'clears the auth_token from the session and redirects with a flash notice' do
      session[:auth_token] = 'some_token'
      delete :destroy
      expect(flash[:notice]).to eq('Logout realizado com sucesso.')
      expect(response).to redirect_to(login_path)
    end
  end
end
