module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, except: [ :index, :create ]

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

      def clock_in
        sleep_record = @user.sleep_records.build(clock_in: Time.current)

        if sleep_record.save
          render json: { data: @user.sleep_records.recent }, status: :created
        else
          render json: { errors: sleep_record.errors }, status: :unprocessable_entity
        end
      end

      def clock_out
        sleep_record = @user.sleep_records.where(clock_out: nil).order(created_at: :desc).first

        if sleep_record
          sleep_record.update(clock_out: Time.current)
          render json: sleep_record
        else
          render json: { error: "No active sleep record found" }, status: :not_found
        end
      end

      private

      def set_user
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "User not found" }, status: :not_found
      end

      def user_params
        params.require(:user).permit(:name)
      end
    end
  end
end
