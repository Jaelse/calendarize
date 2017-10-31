class CreateDepartments < ActiveRecord::Migration[5.1]
  def change
    create_table :departments do |t|
      t.string :deptname
      t.string :deptschool

      t.timestamps
    end
  end
end
