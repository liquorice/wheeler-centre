# This migration comes from heracles (originally 20131203050131)
class ChangePageSlugsToBeNonNil < ActiveRecord::Migration
  def change
    change_column :pages, :slug, :string, null: false
  end
end
