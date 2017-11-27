class AddGcalendarToFaculty < ActiveRecord::Migration[5.1]
  def change
    add_column :faculties, :gcalendar, :string
  end
end
