class StatusController < ApplicationController
  ensure_authenticated_to_facebook
  before_filter :check_session

	def index
    if session[:facebook_session]
      @facebook_user = session[:facebook_session].user
      @user = FacebookUser.find_or_initialize_by_id @facebook_user.id
      @user.save if @user.new_record?
      @statuses = @user.statuses + FacebookStatus.all(:conditions => {:facebook_user_id => @facebook_user.friends.map(&:id)})
      @statuses = @statuses.sort_by(&:created_at)
      @statuses.reverse!
      @status = FacebookStatus.new(params[:status])
    else
      redirect_to '/'
    end
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
  
  def get_friend_statuses
    session[:facebook_session].friends.each do |friend|
      friend = FacebookUser.find_or_initialize friend.id
      friend.save if friend.new_record?
      session[:facebook_session].fql_query("select uid, status_id, time, message from status where uid = #{friend.id}").each do |status|
        friend.statuses.create status
      end
    end
  end

  protected
    def check_session
      begin
        session[:facebook_session].user.name
      rescue Facebooker::Session::SessionExpired
        session[:facebook_session] = nil
      end
    end
end
