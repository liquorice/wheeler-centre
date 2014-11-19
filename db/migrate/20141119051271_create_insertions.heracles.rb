# This migration comes from heracles (originally 20140225025003)
class CreateInsertions < ActiveRecord::Migration
  def change
    create_table :insertions do |t|
      t.uuid :page_id
      t.uuid :insertable_id
      t.string :insertable_type
      t.timestamps
    end

    add_index :insertions, :page_id
    add_index :insertions, [:insertable_id, :insertable_type]
  end
end
