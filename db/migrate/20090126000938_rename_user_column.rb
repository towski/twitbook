class RenameUserColumn < ActiveRecord::Migration
  def self.up
    rename_column :facebook_statuses, :user_id, :facebook_user_id
  end

  def self.down
    rename_column :facebook_statuses, :facebook_user_id, :user_id
  end
end
