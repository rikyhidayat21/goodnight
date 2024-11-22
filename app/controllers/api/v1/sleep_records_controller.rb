module Api
  module V1
    class SleepRecordsController < ApplicationController
      before_action :set_user

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

      def following
        following_ids = @user.following.pluck(:id)

        records = SleepRecord.includes(:user)
                            .where(user_id: following_ids)
                            .where(created_at: 1.week.ago..Time.current)
                            .order(duration_minutes: :desc)

        render json: records, include: { user: { only: [ :id, :name ] } }
      end

      private

      def set_user
        @user = User.find(params[:user_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "User not found" }, status: :not_found
      end
    end
  end
end
