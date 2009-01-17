class MoveTables < ActiveRecord::Migration
  def self.up
		rename_table :statuses, :facebook_statuses
		rename_table :users, :facebook_users
  end

  def self.down
		rename_table :facebook_statuses, :statuses
		rename_table :facebook_users, :users
  end
end
