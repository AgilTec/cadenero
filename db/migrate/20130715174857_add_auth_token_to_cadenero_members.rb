class AddAuthTokenToCadeneroMembers < ActiveRecord::Migration
  def change
    add_column :cadenero_members, :auth_token, :string
    add_index :cadenero_members, :auth_token
  end
end
