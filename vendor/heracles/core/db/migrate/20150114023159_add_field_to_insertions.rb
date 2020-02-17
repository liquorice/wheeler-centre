class AddFieldToInsertions < ActiveRecord::Migration
  def up
    Heracles::Insertion.delete_all

    add_column :insertions, :field, :string, null: false
    add_index :insertions, :field

    puts "Run `rake heracles:pages:rebuild_insertions` to rebuild all insertions now."
  end

  def down
    remove_column :insertions, :field
  end
end
