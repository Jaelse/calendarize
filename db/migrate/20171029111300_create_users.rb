class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :uname
      t.string :uemail
      t.string :udept

      t.timestamps
    end
  end
end
