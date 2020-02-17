class AddInsertionKeyToPages < ActiveRecord::Migration
  def up
    add_column :pages, :insertion_key, :string

    Heracles::Page.find_each do |page|
      page.update_column(:insertion_key, page.insertion_key)
    end

    change_column :pages, :insertion_key, :string, null: false
    add_index :pages, :insertion_key
  end

  def down
    remove_column :pages, :insertion_key
  end
end
