module Api
  module V1
    class UsersController < ApplicationController
      def create
        user = User.create! user_params
        represent_response UserPresenter.new(user)
      end

      private

      def user_params
        params.permit(:name, :email, :password, :password_confirmation)
      end
    end
  end
end
