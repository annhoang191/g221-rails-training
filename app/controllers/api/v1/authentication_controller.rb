module Api
  module V1
    class AuthenticationController < ApplicationController
      before_action :authorize_request, except: :login

      def login
        @user = User.find_by email: params[:email]

        if @user&.authenticate(params[:password])
          token = JsonWebToken.encode user_id: @user.id
          time = Time.now + 24.hours.to_i
          render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                         email: @user.email }, status: :ok
        elsif @user.nil?
          render json: { error: "user not found" }, status: :not_found
        else
          render json: { error: "unauthorized" }, status: :unauthorized
        end
      end
    end
  end
end
