class CreateHeraclesUsers < ActiveRecord::Migration
  def change
    create_table :heracles_users do |t|
      t.string :email, null: false
      t.string :name, null: false
      t.boolean :superadmin, default: false
      t.timestamps
    end
  end
end
