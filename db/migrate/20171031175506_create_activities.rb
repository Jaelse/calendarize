class CreateActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :activities do |t|
      t.string :acttopic
      t.string :acttype
      t.references :secretary, foreign_key: true

      t.timestamps
    end
  end
end
