# This migration comes from heracles (originally 20131110235801)
class EnableUuidOsspExtension < ActiveRecord::Migration
  def change
    enable_extension "uuid-ossp"
  end
end
