module Kaleidoscope
  def self.factory(model, name=nil, definition=nil, &block)
    name ||= :kaleidoscope
    definition = definition || block.call
    definition = { :conditions => definition } if Hash === definition
    model.class_eval do
      named_scope name, definition
    end
  end
end