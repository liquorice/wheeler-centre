# This migration comes from heracles (originally 20131110235831)
class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages, id: :uuid do |t|
      t.string :slug
      t.timestamps
    end
  end
end
