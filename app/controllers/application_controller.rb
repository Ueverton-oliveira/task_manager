class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  private

  def authenticate_user!
    # token = request.headers['Authorization']
    # auth_service = AuthenticationService.validate_token(token)
    #
    # if auth_service.present?
    #   render :index
    # else
    #   render plain: 'Usuário não encontrado', status: :unauthorized
    # end
  end
end
