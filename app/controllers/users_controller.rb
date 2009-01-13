class UsersController < ApplicationController
	def show
		page = 1
		friends = []
		base = Twitter::Base.new("towski@gmail.com",PASSWORD)
		loop do
			page_of_friends = base.friends_for(params[:id], :page => page)
			friends += page_of_friends 
			if page_of_friends.size == 100
				page += 1
			else
				break
			end
		end
		friends_with_data = friends.select{|u| u.status && u.status.created_at }
		recent_friends = friends_with_data.sort_by{|f| DateTime.parse(f.status.created_at) }.reverse[0..19]
		@statuses = []
		recent_friends.each do |user|
		  @statuses += base.timeline(:user, :id => user.screen_name).select{|status| status.in_reply_to_status_id.blank? }.map{|status| [user.screen_name, status.text, DateTime.parse(status.created_at)]}
	  end
	  @statuses = @statuses.sort_by{|name, status, date| date }
	end
end
