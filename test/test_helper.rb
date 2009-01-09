ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
#require 'test_help'
require 'test/unit'
require 'context'
#require 'action_controller/test_process'
require 'action_controller/integration'
require 'rr'
require 'matchy'

class Test::Unit::TestCase
  include RR::Adapters::TestUnit
  self.setup do
    #self.class.suite_context ||= ActiveRecord::Base.context_cache.dup if ActiveRecord::Base.context_cache
    #ActiveRecord::Base.context_cache = self.class.suite_context
    ActiveRecord::Base.connection.increment_open_transactions
    ActiveRecord::Base.connection.begin_db_transaction
  end

  self.teardown do
    ActiveRecord::Base.connection.rollback_db_transaction
    ActiveRecord::Base.verify_active_connections!
  end
end
