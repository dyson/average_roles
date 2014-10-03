class CreateRolesUsers < ActiveRecord::Migration
  def change
    create_table :roles_users do |t|
      t.integer :role_id, null: false
      t.integer :user_id, null: false
    end
  end
end
