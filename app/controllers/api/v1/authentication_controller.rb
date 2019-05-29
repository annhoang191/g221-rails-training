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
        github_url = "https://github.com/login/oauth/access_token?"
        client_id = ENV["GITHUB_CLIENT_ID"]
        client_secret = ENV["GITHUB_CLIENT_SECRET"]
        granted_code = params[:code]
        provider = params[:provider]

        user = GithubOauthService.new(github_url, client_id, client_secret)
                                 .get_access_token(granted_code, provider)
        represent_response data_payload(user.first), Settings.http_code.code_200
      end

      private

      def data_payload user
        token = JsonWebToken.encode user_id: user.id
        time = Time.zone.now + 24.hours.to_i
        { token: token, exp: time.strftime("%m-%d-%Y %H:%M"), email: user.email }
      end
    end
  end
end
