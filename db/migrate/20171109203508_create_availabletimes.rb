class CreateAvailabletimes < ActiveRecord::Migration[5.1]
  def change
    create_table :availabletimes do |t|
      t.string :title
      t.datetime :start
      t.datetime :end
      t.string :color
      t.references :activity, foreign_key: true
      t.references :member, foreign_key: true
      t.references :user, foreign_key: true
      t.references :schedule, foreign_key: true

      t.timestamps
    end
  end
end
