class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name
      t.string :identifier
      t.string :description
      t.integer :parent_id
      t.boolean :active

      t.timestamps
    end
  end
end
