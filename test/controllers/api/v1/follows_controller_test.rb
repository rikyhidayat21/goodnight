require "test_helper"

module Api
  module V1
    class FollowsControllerTest < ActionDispatch::IntegrationTest
      def setup
        @one = users(:one)
        @two = users(:two)
      end

      class CreateTest < FollowsControllerTest
        test "should create follow relationship" do
          assert_difference("Follow.count") do
            post "/api/v1/users/#{@one.id}/follows", params: { followed_id: @two.id }
          end

          assert_response :created
          assert_equal "Successfully followed user", JSON.parse(response.body)["message"]
        end

        test "should not create duplicate follow relationship" do
          Follow.create!(follower: @one, followed: @two)

          assert_no_difference("Follow.count") do
            post "/api/v1/users/#{@one.id}/follows", params: { followed_id: @two.id }
          end

          assert_response :unprocessable_entity
          assert_includes JSON.parse(response.body)["errors"].values.flatten,
                         "unable to follow the same user"
        end

        test "should not allow self-following" do
          assert_no_difference("Follow.count") do
            post "/api/v1/users/#{@one.id}/follows", params: { followed_id: @one.id }
          end
          assert_response :unprocessable_entity
          assert_includes JSON.parse(response.body)["errors"].values.flatten,
                         "unable to follow themselves"
        end

        test "should return not found for non-existent followed user" do
          post "/api/v1/users/#{@one.id}/follows", params: { followed_id: 999999 }
          assert_response :not_found
          assert_equal "User to follow not found", JSON.parse(response.body)["error"]
        end

        test "should return not found for non-existent follower" do
          post "/api/v1/users/999999/follows", params: { followed_id: @two.id }
          assert_response :not_found
        end
      end

      class DestroyTest < FollowsControllerTest
        test "should destroy follow relationship" do
          Follow.create!(follower: @one, followed: @two)

          assert_difference("Follow.count", -1) do
            delete "/api/v1/users/#{@one.id}/follows", params: { followed_id: @two.id }
          end
          assert_response :success
          assert_equal "Successfully unfollowed user", JSON.parse(response.body)["message"]
        end

        test "should return not found when unfollowing non-followed user" do
          delete "/api/v1/users/#{@one.id}/follows", params: { followed_id: @two.id }
          assert_response :not_found
          assert_equal "Follow relationship not found", JSON.parse(response.body)["error"]
        end

        test "should return not found for non-existent user when unfollowing" do
          delete "/api/v1/users/999999/follows"
          assert_response :not_found
        end

        test "should return not found when unfollowing non-existent user" do
          delete "/api/v1/users/#{@one.id}/follows", params: { followed_id: 999999 }
          assert_response :not_found
        end
      end
    end
  end
end
