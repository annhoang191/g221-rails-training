module Api
  module V1
    class AuthenticationController < ApplicationController
      before_action :authorize_request, except: :login

      def login
        user = User.find_by! email: params[:email]

        raise Error::UnauthorizedError.new unless user&.authenticate(params[:password])

        token = JsonWebToken.encode user_id: user.id
        time = Time.now + 24.hours.to_i
        data = { token: token, exp: time.strftime("%m-%d-%Y %H:%M"), email: user.email }
        represent_response data
      end
    end
  end
end
