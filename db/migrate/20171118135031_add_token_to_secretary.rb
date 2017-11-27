class AddTokenToSecretary < ActiveRecord::Migration[5.1]
  def change
    add_column :secretaries, :token, :string
  end
end
