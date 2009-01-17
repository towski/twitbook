class AddTwitterTables < ActiveRecord::Migration
  def self.up
		create_table :twitter_users do |t|
			t.timestamps
			t.datetime :user_created_at
			t.string :screen_name
			t.string :profile_image_url
		end

		create_table :twitter_statuses do |t|
			t.timestamps
			t.integer :in_reply_to_status_id
			t.integer :in_reply_to_user_id
			t.integer :twitter_user_id
			t.string :text
		end

		create_table :twitter_followings do |t|
			t.timestamps
			t.integer :user_id
			t.integer :following_id
		end
  end

  def self.down
  end
end
