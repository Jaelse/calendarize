class CreateSuperadmins < ActiveRecord::Migration[5.1]
  def change
    create_table :superadmins do |t|
      t.string :suadusername
      t.string :suadpassword_hash
      t.string :suadpassword_salt

      t.timestamps
    end
  end
end
