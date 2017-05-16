# This migration comes from heracles (originally 20150729002708)
class RemoveOriginalPrefixFromAssets < ActiveRecord::Migration
  def change
    remove_column :assets, :original_prefix, :string, null: false
  end
end
