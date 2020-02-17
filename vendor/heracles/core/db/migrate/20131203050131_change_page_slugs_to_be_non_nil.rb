class ChangePageSlugsToBeNonNil < ActiveRecord::Migration
  def change
    change_column :pages, :slug, :string, null: false
  end
end
