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
	  begin
	    user.set_status params[:status][:message]
	    @user = User.find user.id
  	  @user.statuses.create! :message => params[:status][:message]
  	  redirect_to '/'
    rescue Facebooker::Session::ExtendedPermissionRequired => e
      redirect_to "http://www.facebook.com/authorize.php?api_key=#{ENV['FACEBOOK_API_KEY']}&ext_perm=status_update&v=1.0"
    end
  end
end
