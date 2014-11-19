# This migration comes from heracles (originally 20140809142442)
class ReplaceInsertionsInsertableIdWithInsertedKey < ActiveRecord::Migration
  def up
    remove_column :insertions, :insertable_id
    remove_column :insertions, :insertable_type

    add_column :insertions, :inserted_key, :string
    add_index :insertions, :inserted_key
  end

  def down
    remove_column :insertions, :inserted_key

    add_column :insertions, :insertable_id, :uuid
    add_column :insertions, :insertable_type, :string
    add_index :insertions, [:insertable_id, :insertable_type]
  end
end
