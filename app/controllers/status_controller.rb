class StatusController < ApplicationController
  ensure_authenticated_to_facebook

	def index
		@facebook_user = session[:facebook_session].user
		@user = User.find_or_initialize_by_id @facebook_user.id
		@user.save if @user.new_record?
    Delayed::Job.enqueue Job::FetchStatuses.new(@user.id)
		@statuses = @user.statuses + Status.all(:conditions => {:user_id => @facebook_user.friends.map(&:id)})
		@status = Status.new(params[:status])
	end
	
	def create
	  user = session[:facebook_session].user
	  begin
	    user.set_status params[:status][:message]
	    @user = User.find user.id
  	  @user.statuses.create! :message => params[:status][:message]
  	  redirect_to '/'
    rescue Facebooker::Session::ExtendedPermissionRequired => e
      redirect_to url_for(:host => "www.facebook.com", 
        :action => "authorize.php", :api_key => ENV['FACEBOOK_API_KEY'], 
        :v => "1.0", :ext_perm => "status_update", :next => root_url(:status => params[:status]), 
        :next_cancel => root_url(:status => params[:status]))
    end
  end
end
