class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  private

  def authenticate_user!
    unless current_user
      redirect_to login_path, alert: 'Você precisa estar logado para acessar esta página.'
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
