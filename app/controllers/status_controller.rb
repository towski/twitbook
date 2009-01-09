class StatusController < ApplicationController
  ensure_authenticated_to_facebook

	def index
		@facebook_user = session[:facebook_session].user
		@user = User.find_or_initialize_by_id @facebook_user.id
		@user.save if @user.new_record?
    Delayed::Job.enqueue Job::FetchStatuses.new(@user.id)
		@statuses = @user.statuses + Status.all(:conditions => {:user_id => @facebook_user.friends.map(&:id)})
	end
	
	def create
	  user = session[:facebook_session].user
	  @user = User.find user.id
	  @user.statuses.create! :message => params[:status][:message]
	  user.set_status params[:status][:message]
	  redirect_to '/'
  end
end
