class SleepRecord < ApplicationRecord
  belongs_to :user

  before_save :calculate_sleep_duration, if: :clock_out?

  scope :recent, -> { order(created_at: :desc) }

  private

  def calculate_sleep_duration
    self.duration_minutes = ((clock_out - clock_in) / 60).to_i
  end
end
