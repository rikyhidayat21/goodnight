require "test_helper"

module Api
  module V1
    class SleepRecordsControllerTest < ActionDispatch::IntegrationTest
      def setup
        @one = users(:one)
        @two = users(:two)
        # travel_to Time.zone.local(2024, 1, 1, 12, 0, 0)
      end

      class ClockInTest < SleepRecordsControllerTest
        test "should return not found for non-existing user" do
          post "/api/v1/users/999999/sleep_records/clock_in"
          assert_response :not_found
        end

        # TODO: develop this feature to prevent multiple clock_in data
        # test "should not create sleep records with existing data" do
        #   SleepRecord.create!(user: @one, clock_in: 1.hour.ago)

        #   assert_no_difference("SleepRecord.count") do
        #     post "/api/v1/users/#{@one.id}/sleep_records/clock_in"
        #   end

        #   assert_response :unprocessable_entity
        # end

        test "should create sleep records" do
          assert_difference("SleepRecord.count") do
            post "/api/v1/users/#{@one.id}/sleep_records/clock_in"
          end
          assert_response :created
        end
      end
    end
  end
end
