class CreateCacheBusters < ActiveRecord::Migration
  def change
    create_table :cache_busters do |t|
      t.string :path, null: false
      t.string :checksum

      t.index :path, unique: true

      t.timestamps
    end
  end
end
