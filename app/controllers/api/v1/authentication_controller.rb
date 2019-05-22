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
        get_access_token_response = Faraday.post github_url + "client_id=#{client_id}&client_secret=#{client_secret}&code=#{granted_code}"

        returned_string = get_access_token_response.body.split("&")
        response_hash = {}
        returned_string.each do |string|
          key, value = string.split("=")
          response_hash[key] = value
        end

        access_token = response_hash["access_token"]
        user_github_info = Faraday.get "https://api.github.com/user?access_token=#{access_token}"
        auth = JSON.parse(user_github_info.body)

        user = User.find_or_create_by uid: auth["id"]
        user.name = auth["login"]
        user.email = auth["email"]
        user.password = "Aa@123456"
        user.password_confirmation = "Aa@123456"
        user.uid = auth["id"]
        user.provider = provider
        user.save!

        represent_response data_payload(user), Settings.http_code.code_200
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
