class TwitterUser < ActiveRecord::Base
  MAX_PAGE_NUMBER = 100
  MAX_USER_TIMELINE_COUNT = 200
  has_many :twitter_followings, :foreign_key => 'following_id'
  has_many :friends, :through => :twitter_followings, :source => :twitter_user
  has_many :statuses, :class_name => "TwitterStatus", :dependent => :destroy
  cattr_accessor :password
  
  def before_create
    self.id = @twitter_id
  end
  
  def twitter_id=(twitter_id)
    @twitter_id = twitter_id
  end
  
  def twitter_id
    @twitter_id
  end
  
  def self.base
    @@base ||= Twitter::Base.new("towski", password)
  end
  
  def self.find_or_create_from_twitter screen_name, user = nil
    result = find_by_screen_name(screen_name)
    if !result
      if user.nil?
        user = base.user(screen_name)
      end
      result = create(:screen_name => user.screen_name, 
             :profile_image_url    => user.profile_image_url, 
             :twitter_id           => user.id)
      result.statuses.build.from_twitter user.status if user.status
    else 
      result.statuses.build.from_twitter user.status if user && user.status
    end
    result
  end
  
  def set_friends
    (1..MAX_PAGE_NUMBER).each do |page|
      friends = self.class.base.friends(:id => screen_name, :page => page)
      friends.each do |user|
        local_user = self.class.find_or_create_from_twitter(user.screen_name, user)
        self.friends << local_user unless friends.include?(local_user)
      end
      break if friends.size < 100
    end
  end
  
  def update
    set_friends
    friends_statuses.map(&:twitter_user).each do |user|
      user.set_statuses
    end
  end
  
  def since_id
    statuses.count > 10 ? statuses.all(:order => "id desc", :limit => 1).first.id : 1
  end
  
  def set_statuses
    self.class.base.timeline(:user, :id => screen_name, :count => MAX_USER_TIMELINE_COUNT, :since_id => since_id).each do |status|
      statuses.build.from_twitter status
    end
  end
  
  def friends_statuses
    TwitterStatus.all(:conditions => ["twitter_users.id in (?) and text not like ? ", friends, "%@%"], :include => :twitter_user, :order => "twitter_statuses.created_at DESC", :limit => 20)
  end
end