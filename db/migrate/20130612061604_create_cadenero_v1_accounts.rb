class CreateCadeneroV1Accounts < ActiveRecord::Migration
  def change
    create_table :cadenero_accounts do |t|
      t.string :name
      t.string :subdomain
      t.string :auth_token
      t.references :owner

      t.timestamps
    end
    add_index :cadenero_accounts, :owner_id
    add_index :cadenero_accounts, :auth_token
  end
end
