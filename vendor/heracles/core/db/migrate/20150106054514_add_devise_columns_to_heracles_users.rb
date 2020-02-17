class AddDeviseColumnsToHeraclesUsers < ActiveRecord::Migration
  def change
    # Database authenticatable
    add_column :heracles_users, :encrypted_password, :string, null: false, default: ""

    # Recoverable
    add_column :heracles_users, :reset_password_token, :string
    add_column :heracles_users, :reset_password_sent_at, :datetime

    # Rememberable
    add_column :heracles_users, :remember_created_at, :datetime

    # Trackable
    add_column :heracles_users, :sign_in_count, :integer, default: 0, null: false
    add_column :heracles_users, :current_sign_in_at, :datetime
    add_column :heracles_users, :last_sign_in_at, :datetime
    add_column :heracles_users, :current_sign_in_ip, :string
    add_column :heracles_users, :last_sign_in_ip, :string

    # Lockable
    add_column :heracles_users, :failed_attempts, :integer, default: 0, null: false # Only if lock strategy is :failed_attempts
    add_column :heracles_users, :unlock_token, :string # Only if unlock strategy is :email or :both
    add_column :heracles_users, :locked_at, :datetime

    add_index :heracles_users, :email,                 unique: true
    add_index :heracles_users, :reset_password_token,  unique: true
    add_index :heracles_users, :unlock_token,          unique: true
  end
end
