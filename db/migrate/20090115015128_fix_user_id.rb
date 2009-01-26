class FixUserId < ActiveRecord::Migration
  def self.up
		rename_column :twitter_followings, :user_id, :twitter_user_id
  end

  def self.down
		rename_column :twitter_followings, :twitter_user_id, :user_id
  end
end
