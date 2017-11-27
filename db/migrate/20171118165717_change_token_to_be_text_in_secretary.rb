class ChangeTokenToBeTextInSecretary < ActiveRecord::Migration[5.1]
  def change
    change_column :secretaries, :token, :text
    change_column :secretaries, :gcalendar, :text
  end
end
