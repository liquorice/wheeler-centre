class AddQueAgain < ActiveRecord::Migration
  def up
    Que.migrate!
  end

  def down
    drop_table :que_jobs
  end
end
