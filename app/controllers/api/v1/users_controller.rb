module Api
  module V1
    class UsersController < ApplicationController
      def index
        users = User.select(:id, :name)

        render json: users
      end

      def create
        user = User.new(user_params)

        if user.save
          render json: user, status: :created
        else
          render json: { errors: user.errors }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:name)
      end
    end
  end
end
