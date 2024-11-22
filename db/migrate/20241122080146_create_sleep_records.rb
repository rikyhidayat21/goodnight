class CreateSleepRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :sleep_records do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.timestamp :clock_in, null: false
      t.timestamp :clock_out
      t.integer :duration_minutes

      t.timestamps
    end
  end
end
