class CreateBulkPublicationActions < ActiveRecord::Migration
  def change
    create_table :bulk_publication_actions do |t|
      t.integer :user_id
      t.uuid :site_id
      t.text :tags
      t.string :action

      t.datetime :created_at
      t.datetime :completed_at
    end
  end
end
