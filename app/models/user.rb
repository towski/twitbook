class User < ActiveRecord::Base
  has_many :statuses
  
  def fetch_friends_replies
    raise "URL not specified" unless url
    JSON::load(open(google_reader_url))['items'].select{|i| i["title"] =~ /commented/ }.each do |item|
      item["summary"]["content"].match(%r(<a href=\"http://www.facebook.com/profile.php\?id=(\d*)\">([\w ]*)</a>))
      status = Status.find_or_initialize_by_message_and_created_at :message => item["summary"]["content"], :user_id => $1, :created_at => Time.at(item["published"]) 
      status.save! if status.new_record?
    end
  end
  
  def google_reader_url
    "http://www.google.com/reader/api/0/stream/contents/feed/" + URI.escape(url.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")) + "?r=n&n=25&client=scroll"
  end
end