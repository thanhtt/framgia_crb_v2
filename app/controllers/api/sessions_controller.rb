class Api::SessionsController < ApplicationController
  include Authenticable

  protect_from_forgery with: :null_session
  skip_before_action :authenticate_user!, only: [:create, :destroy]

  respond_to :json

  def create
    user_password = request.headers[:password]
    user_email = request.headers[:email]
    user = user_email.present? && User.find_by(email: user_email)
    if user.present?
      if user.valid_password? user_password
        sign_in user, store: false
        user.generate_authentication_token!
        user.save
        return render json: {
          message: I18n.t("api.login_success"),
          user: user
        }, status: 200
      end
    end
    render json: {errors: I18n.t("api.invalid_email_or_password")}, status: 422
  end

  def destroy
    if current_user.present?
      sign_out current_user
      current_user.generate_authentication_token!
      render json: {
        message: t("api.success_sign_out")
      }, status: :ok
    else
      render json: {errors: I18n.t("api.failed_sign_out")}
    end
  end
end
