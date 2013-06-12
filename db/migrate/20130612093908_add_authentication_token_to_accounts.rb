class AddAuthenticationTokenToAccounts < ActiveRecord::Migration
  def change
    add_column :cadenero_accounts, :authentication_token, :string
    add_index :cadenero_accounts, :authentication_token
  end
end
