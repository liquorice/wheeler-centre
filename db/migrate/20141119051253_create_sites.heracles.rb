# This migration comes from heracles (originally 20131112012306)
class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites, id: :uuid do |t|
      t.string :title
      t.string :hostnames, array: true, default: []

      t.timestamps
    end
    add_index :sites, :hostnames, using: 'gin'
  end
end
