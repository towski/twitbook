class TwitterStatus < ActiveRecord::Base
  belongs_to :twitter_user
  
  def from_twitter status
    unless self.class.exists?(status.id)
      update_attributes(          :text  => status.text,
       :in_reply_to_status_id => status.in_reply_to_status_id, 
       :in_reply_to_user_id   => status.in_reply_to_user_id,
       :twitter_user_id       => twitter_user_id,
       :twitter_id            => status.id,
       :created_at            => (status.created_at ? DateTime.parse(status.created_at) : nil))
    end
  end
  
  def before_create
    self.id = @twitter_id
  end
  
  def twitter_id=(twitter_id)
    @twitter_id = twitter_id
  end
  
  def twitter_id
    @twitter_id
  end
end