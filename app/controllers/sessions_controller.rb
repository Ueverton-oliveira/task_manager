class SessionsController < ApplicationController
  add_flash_types :warning

  skip_before_action :authenticate_user!, only: [:new, :create, :login, :authenticate]


  def new
    @user = User.new
    render 'sessions/new'
  end

  def create
    response = AuthenticationService.register(params[:email], params[:password], params[:name])

    if response[:success]
      redirect_to login_path, notice: 'Usuário registrado com sucesso! Por favor, faça login.'
    else
      flash.now[:alert] = response[:errors].join(', ')
      render :new
    end
  end

  def login
    render 'sessions/login'
  end

  def authenticate
    response = AuthenticationService.login(params[:email], params[:password])

    if response[:success]
      session[:auth_token] = response[:token]
      redirect_to root_path, notice: 'Login realizado com sucesso!'
    else
      flash[:alert] = response[:errors].join(', ')
      redirect_to login_path
    end
  end

  def destroy
    session[:auth_token] = nil
    flash.now[:notice] = 'Logout realizado com sucesso.'
    redirect_to login_path
  end
end
