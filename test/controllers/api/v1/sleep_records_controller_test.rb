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

      class ClockOutTest < SleepRecordsControllerTest
        test "should return not found for non-existing user" do
          post "/api/v1/users/999999/sleep_records/clock_out"
          assert_response :not_found
        end

        test "should return not found when no active sleep record" do
          post "/api/v1/users/#{@one.id}/sleep_records/clock_out"

          assert_response :not_found
          assert_equal "No active sleep record found", JSON.parse(response.body)["error"]
        end

        test "should update sleep record with clock out time" do
          SleepRecord.create!(user: @one, clock_in: 1.hour.ago)

          post "/api/v1/users/#{@one.id}/sleep_records/clock_out"
          response_data = JSON.parse(response.body)
          assert_not_nil response_data["clock_out"]
        end
      end

      class FollowingTest < SleepRecordsControllerTest
        def setup
          super
          @two = users(:two)
          @three = users(:three)
          @four = users(:four)

          Follow.create!(follower: @one, followed: @two)
          Follow.create!(follower: @one, followed: @three)

          @recent_record1 = SleepRecord.create!(
            user: @two,
            clock_in: 2.days.ago,
            clock_out: 2.days.ago + 8.hours
          )
          @recent_record2 = SleepRecord.create!(
            user: @three,
            clock_in: 3.days.ago,
            clock_out: 3.days.ago + 6.hours
          )

          # Create old record (shouldn't be included)
          @old_record = SleepRecord.create!(
            user: @two,
            clock_in: 2.weeks.ago,
            clock_out: 2.weeks.ago + 7.hours
          )

          # Create record for non-followed user (shouldn't be included)
          @non_followed_record = SleepRecord.create!(
            user: @four,
            clock_in: 1.day.ago,
            clock_out: 1.day.ago + 8.hours
          )
        end

        test "should return not found for non-existing user" do
          get "/api/v1/users/999999/sleep_records/following"
          assert_response :not_found
        end

        test "should return empty array when user follows no one" do
          Follow.where(follower: @one).destroy_all

          get "/api/v1/users/#{@one.id}/sleep_records/following"

          assert_response :success
          assert_empty JSON.parse(response.body)
        end

        test "should order records by duration in descending order" do
          get "/api/v1/users/#{@one.id}/sleep_records/following"

          assert_response :success
          records = JSON.parse(response.body)
          durations = records.map { |r| r["duration_minutes"] }

          assert_equal durations.sort.reverse, durations
        end

        test "should include basic user information in response" do
          get "/api/v1/users/#{@one.id}/sleep_records/following"

          assert_response :success
          record = JSON.parse(response.body).first

          assert_includes record, "user"
          assert_equal [ :id, :name ].sort, record["user"].keys.map(&:to_sym).sort
        end

        # TODO: check test below
        # test "should get sleep records of followed users from last week" do
        #   get "/api/v1/users/#{@one.id}/sleep_records/following"

        #   assert_response :success
        #   response_data = JSON.parse(response.body)

        #   assert_equal 2, response_data.length
        #   assert_includes response_data.map { |r| r["id"] }, @recent_record1.id
        #   assert_includes response_data.map { |r| r["id"] }, @recent_record2.id
        #   assert_not_includes response_data.map { |r| r["id"] }, @old_record.id
        #   assert_not_includes response_data.map { |r| r["id"] }, @non_followed_record.id
        # end
      end
    end
  end
end
