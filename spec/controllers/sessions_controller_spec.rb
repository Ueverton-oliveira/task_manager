# spec/controllers/sessions_controller_spec.rb
require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'POST #create' do
    context 'with valid registration' do
      it 'redirects to login path with notice' do
        allow(AuthenticationService).to receive(:register).and_return(success: true)
        post :create, params: { email: 'test@example.com', password: 'password' }
        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to eq('Usuário registrado com sucesso! Por favor, faça login.')
      end
    end

    context 'with invalid registration' do
      it 'renders new with flash alert' do
        allow(AuthenticationService).to receive(:register).and_return(success: false, errors: ['Email já está em uso'])
        post :create, params: { email: 'test@example.com', password: 'password' }
        expect(response).to render_template(:new)
        expect(flash[:alert]).to eq('Email já está em uso')
      end
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
    it 'clears the session and redirects to login path' do
      delete :destroy
      expect(session[:auth_token]).to be_nil
      expect(response).to redirect_to(login_path)
      expect(flash[:notice]).to eq('Logout realizado com sucesso.')
    end
  end
end
