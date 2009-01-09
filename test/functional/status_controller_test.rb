require File.expand_path(File.dirname(__FILE__) + "/../test_helper")

class StatusControllerTest < ActionController::TestCase
  def setup
    ENV["FACEBOOK_API_KEY"] = "95a71599e8293s66f1f0a6f4aeab3df7"
    ENV["FACEBOOK_SECRET_KEY"] = "3e4du8eea435d8e205a6c9b5d095bed1"
    @session = Facebooker::Session.create(ENV['FACEBOOK_API_KEY'], ENV['FACEBOOK_SECRET_KEY'])
    @session.secure_with!("c452b5d5d60cbd0a0da82021-744961110", "1111111", Time.now.to_i + 60)
    @controller.stubs(:verify_signature).returns(true)
  end
  
  test "index gets statuses" do
    Status.create! :facebook_id => @session.user.id, :message => "HEY"
    stub(@session.user).pic_square { "hey.jpg" }
    stub(@session.user).name { "Charlie" }
    stub(@session.user).status { stub(nil).message{ "hey" } }
    get :index, example_rails_params_including_fb, {:facebook_session => @session}
    assigns(:statuses).size.should == 1
  end
  
  test "create creates user" do
    session = Facebooker::Session.create(ENV['FACEBOOK_API_KEY'], ENV['FACEBOOK_SECRET_KEY'])
    session.secure_with!("c452b5d5d60cbd0a0da82021-744961110", "1111111", Time.now.to_i + 60)
    post :create, example_rails_params_including_fb, {:facebook_session => session}
    assigns(:statuses).size.should == 1
  end
  
  private
    def example_rails_params_including_fb
      {"fb_sig_time"=>"1186588275.5988", "fb_sig"=>"7371a6400329b229f800a5ecafe03b0a", 
        "action"=>"index", "fb_sig_session_key"=>"c452b5d5d60cbd0a0da82021-744961110", 
        "fb_sig_expires"=>"0", "fb_sig_friends"=>"873695441", "fb_sig_added"=>"0", 
        "fb_sig_user"=>"744961110", "fb_sig_profile_update_time"=>"1180712453"}
    end
end
