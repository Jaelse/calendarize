class CreateSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :schedules do |t|
      t.string :schname
      t.datetime :schdate
      t.boolean :schstart
      t.boolean :schfinished
      t.datetime :schdeadline
      t.references :activity, foreign_key: true

      t.timestamps
    end
  end
end
