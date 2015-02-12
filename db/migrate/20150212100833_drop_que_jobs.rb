class DropQueJobs < ActiveRecord::Migration
  def up
    drop_table :que_jobs
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
