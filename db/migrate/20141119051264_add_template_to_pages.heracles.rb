# This migration comes from heracles (originally 20140122035219)
class AddTemplateToPages < ActiveRecord::Migration
  def change
    add_column :pages, :template, :string
  end
end
