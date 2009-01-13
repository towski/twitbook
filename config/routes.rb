ActionController::Routing::Routes.draw do |map|
  map.with_options :controller => 'status' do |g|
    g.index         'status',                           :action => 'index',      :conditions => { :method => :get }
    g.create        'status',                           :action => 'create',      :conditions => { :method => :post }
		g.authorize     'authorize.php'	, :action => 'authorize.php'												
  end
  
  map.with_options :controller => 'users' do |g|
    g.index         'users/:id',                           :action => 'show',      :conditions => { :method => :get }
  end  
  map.root :controller => 'status', :action => 'index'
end
