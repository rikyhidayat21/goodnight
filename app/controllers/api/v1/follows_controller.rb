module Api
  module V1
    class FollowsController < ApplicationController
      include UserLookup

      before_action :set_user
      before_action :set_followed_user, only: :create

      def create
        follow = @user.active_follows.build(followed: @followed_user)

        if follow.save
          render json: { message: "Successfully followed user" }, status: :created
        else
          render json: { errors: follow.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        followed = @user.active_follows.find_by(followed_id: params[:followed_id])

        if followed&.destroy
          render json: { message: "Successfully unfollowed user" }
        else
          render json: { error: "Follow relationship not found" }, status: :not_found
        end
      end

      private

      def set_followed_user
        @followed_user = User.find(params[:followed_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "User to follow not found" }, status: :not_found
      end
    end
  end
end
