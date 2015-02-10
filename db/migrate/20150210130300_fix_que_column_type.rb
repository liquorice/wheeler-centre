class FixQueColumnType < ActiveRecord::Migration
  def change
    change_column :que_jobs, :queue, 'text USING CAST(queue AS text)'
  end
end
