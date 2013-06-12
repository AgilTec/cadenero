class CreateCadeneroV1Users < ActiveRecord::Migration
  def change
    create_table :cadenero_users do |t|
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end
