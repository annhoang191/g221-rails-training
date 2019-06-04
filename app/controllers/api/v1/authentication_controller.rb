module Api
  module V1
    class AuthenticationController < ApplicationController
      before_action :authorize_request, except: %i(login oauth2)

      def login
        user = User.find_by! email: params[:email]
        raise Error::UnauthorizedError.new unless user&.authenticate(params[:password])

        represent_response data_payload(user), Settings.http_code.code_200
      end

      def oauth2
        granted_code = params[:code]
        provider = params[:provider]
        user = GithubOauthService.new.perform granted_code, provider
        represent_response data_payload(user), Settings.http_code.code_200
      end

      private

      def data_payload user
        token = JsonWebToken.encode user_id: user.id
        time = Time.current + 1.day
        { token: token, exp: time.strftime("%m-%d-%Y %H:%M"), email: user.email }
      end
    end
  end
end
