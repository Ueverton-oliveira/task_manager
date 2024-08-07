class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  private

  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last

    if token.present?
      if AuthenticationService.validate_token(token)
        @current_user = AuthenticationService.fetch_user_from_token(token)
      else
        render plain: 'Usuário não encontrado', status: :unauthorized
      end
    else
      redirect_to login_path
    end
  end

  def current_user
    @current_user
  end
end
