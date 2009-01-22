require "test/unit"
require File.dirname(__FILE__) + "/../lib/kaleidoscope"

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")

module TestHelpers
  class User < ActiveRecord::Base
    named_scope :lives_in, lambda {|country| { :conditions => { :country => country }}}
    
    def self.create_table
      connection.create_table table_name do |t|
        t.string     :name
        t.string     :email
        t.string     :password
        t.string     :country
        t.boolean    :admin, :default => false
        t.timestamps
      end
    end
    
    def self.drop_table
      connection.drop_table table_name
    end
  end

  Kaleidoscope.define do
    factory(User) {{ :name => "Foo Bar", :email => "foo@bar.com", :password => "test" }}
    factory(User, :admin) {{ :admin => true }}
    factory(User, :named) do
      lambda {|name| { :conditions => { :name => name }}}
    end
  end
end

class TestKaleidoscope < Test::Unit::TestCase
  include TestHelpers
  
  def setup
    User.create_table
  end
  
  def teardown
    User.drop_table
  end
  
  def test_models_are_created_with_correct_attributes
    user = User.factory.create
    
    assert_equal "Foo Bar", user.name
    assert_equal "foo@bar.com", user.email
    assert_equal "test", user.password
    assert !user.admin?
  end
  
  def test_you_can_overwrite_attributes_the_normal_activerecord_way
    user = User.admin.create(:name => "John")
    
    assert_equal "John", user.name
    assert user.admin?
  end
  
  def test_models_can_chain_factory_scopes
    user = User.admin.named("John").create
    
    assert_equal "John", user.name
    assert user.admin?
  end
  
  def test_raises_when_you_declare_duplicate_factory
    assert_raise ArgumentError do
      Kaleidoscope.factory(User) {{ :name => "Bar Foo" }}
    end
  end
  
  def test_works_with_existing_named_scopes_in_the_model
    user = User.factory.lives_in("Uruguay").create
    
    assert_equal "Uruguay", user.country
    assert_equal "Foo Bar", user.name
    assert_equal "foo@bar.com", user.email
  end
end