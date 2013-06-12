class CreateCadeneroV1AccountsUsers < ActiveRecord::Migration
  def change
    create_table :cadenero_accounts_users do |t|
      t.references :account
      t.references :user

      t.timestamps
    end
    add_index :cadenero_accounts_users, :account_id
    add_index :cadenero_accounts_users, :user_id
  end
end
