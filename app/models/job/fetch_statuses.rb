class Job::FetchStatuses < Struct.new(:user_id)
  def perform
    user.fetch_friends_replies
  end
  
  def user
    @user ||= User.find(user_id)
  end
end
