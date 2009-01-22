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
end