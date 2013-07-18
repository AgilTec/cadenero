class RenameAuthenticationTokenToV1Account < ActiveRecord::Migration
  def change
    rename_column :cadenero_accounts, :authentication_token, :auth_token
    add_index :cadenero_accounts, :auth_token
    remove_index :cadenero_accounts, :authentication_token
  end
end
