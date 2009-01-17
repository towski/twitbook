class TwitterFollowing < ActiveRecord::Base
  belongs_to :twitter_user
  belongs_to :following
end