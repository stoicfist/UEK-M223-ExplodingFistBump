# app/controllers/registrations_controller.rb
class RegistrationsController < ApplicationController
  include Authentication
  skip_before_action :require_authentication

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      start_new_session_for(@user)
      redirect_to after_authentication_url, notice: "Welcome!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    allowed = [:email_address, :password, :password_confirmation]
    if params[:user].is_a?(ActionController::Parameters)
      params.require(:user).permit(*allowed)     # verschachtelte Form
    else
      params.permit(*allowed)                    # flache Form (Tests)
    end
  end
end
