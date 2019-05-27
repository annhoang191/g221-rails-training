module Api
  module V1
    class AuthenticationController < ApplicationController
      before_action :authorize_request, except: %i(login oauth2)

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

      def oauth2
        github_url = "https://github.com/login/oauth/access_token?"
        client_id = ENV["GITHUB_CLIENT_ID"]
        client_secret = ENV["GITHUB_CLIENT_SECRET"]
        granted_code = params[:code]
        provider = params[:provider]
        response = Faraday.post(github_url + "client_id=#{client_id}&client_secret=#{client_secret}&code=#{granted_code}")

        pairs = response.body.split("&")
        response_hash = {}
        pairs.each do |pair|
          key, value = pair.split("=")
          response_hash[key] = value
        end
        access_token = response_hash["access_token"]
        user_github_info = Faraday.get("https://api.github.com/user?access_token=#{access_token}")
        auth = JSON.parse(user_github_info.body)

        user = User.find_or_create_by uid: auth["id"]
        user.name = auth["login"]
        user.email = auth["email"]
        user.uid = auth["id"]
        user.provider = provider
        user.save!

        token = JsonWebToken.encode user_id: user.uid
        time = Time.now + 24.hours.to_i
        render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
          email: user.email }, status: :ok
      end
    end
  end
end
