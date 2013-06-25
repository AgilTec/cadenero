class CreateCadeneroV1Members < ActiveRecord::Migration
  def change
    create_table :cadenero_members do |t|
      t.references :account
      t.references :user

      t.timestamps
    end
    add_index :cadenero_members, :account_id
    add_index :cadenero_members, :user_id
  end
end
