class AddGcalendarToSecretary < ActiveRecord::Migration[5.1]
  def change
    add_column :secretaries, :gcalendar, :string
  end
end
