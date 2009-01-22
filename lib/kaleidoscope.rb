require "rubygems"
require "activerecord"

module Kaleidoscope
  # Setup simple and clean factories for activerecord using named_scopes
  # (no touching of the internals!)
  # 
  #   Kaleidoscope.factory(User) {{ 
  #     :email => Faker::Internet.email, 
  #     :password => "test", 
  #     :password_confirmation => "test" 
  #   }}
  #
  #   User.kaleidoscope.create #=> #<User id: 1, email: "foo@bar.com", ...>
  #   User.kaleidoscope.new    #=> #<User id: nil, email: "bar@foo.com" ...>
  # 
  #   Kaleidoscope.factory(User, :admin) {{
  #     :admin => true
  #   }}
  #
  #   User.admin.create #=> #<User id: 1, admin: true, ...>
  def self.factory(model, name=nil, &block)
    name ||= :factory
    raise ArgumentError, "#{model.name} already has a #{name} method" if model.respond_to?(name)
    definition = block.call
    definition = { :conditions => definition } if Hash === definition
    model.named_scope name, definition
  end
  
  # Call this to define multiple factories together. Only for aesthetic reasons.
  #
  #   Kaleidoscope.define do
  #     factory(User, :admin) {{ :admin => true }}
  #     factory(User, :inactive) {{ :state => 'pending' }}
  #   end
  def self.define(&block)
    module_eval(&block)
  end
  
  # Generate a unique value each time it's called (starting from zero)
  # if passed a block it passes the value to the block and returns the output
  #
  #   Kaleidoscope.factory(User) {{ :login => "user_#{Kaleidoscope.unique}" }}
  #
  #   User.factory.create #=> #<User login: "user_0">
  #   User.factory.create #=> #<User login: "user_1">
  #   ...etc...
  def self.unique(&block)
    @unique_value ||= -1
    @unique_value += 1
    block ||= lambda {|i| i }
    block.call(@unique_value)
  end
  
  # Reset the unique generator so the next unique value generated is zero again
  # Useful to run between tests to get predictable values.
  def self.reset_uniques!
    @unique_value = -1
  end
end