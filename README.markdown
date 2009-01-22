Kaleidoscope
============

**Simple** and **clean** object factories for ActiveRecord objects.

Kaleidoscopes are ridiculously simple objects, and they provide us with
beautiful images with almost no work on our part.

Example plz?
------------

    Kaleidoscope.define do
      factory(User) {{ :name => "Foo Bar", :email => "foo@bar.com", :password => "test" }}
      factory(User, :admin) {{ :admin => true }}
      factory(User, :named) do
        lambda {|name| { :conditions => { :name => name }}}
      end
    end
    
    User.factory.create #=> #<User id: 1, name: "Foo Bar", email: "foo@bar.com", password: "test", admin: false>
    User.admin.create #=> #<User id: 2, name: nil, email: nil, password: nil, admin: true>
    
    # Overwriting values
    User.factory.create(:name => "foca") #=> #<User id: 3, name: "foca", email: "foo@bar.com", password: "test", admin: false>
    
    # Don't save values automatically
    User.factory.new #=> #<User id: nil, ...>

Generating unique values
------------------------

Most of the time, our models require certain fields to have unique content. In 
order to generate that with Kaleidoscope, just call `Kaleidoscope.unique`:

    Kaleidoscope.unique #=> 0
    Kaleidoscope.unique #=> 1
    # and so on, and so forth
    
If you need repeatable values, call `Kaleidoscope.reset_uniques!` and the next
call to `Kaleidoscope.unique` will return 0 again.

You can pass a block to `unique`, in which case we will pass the unique value
to the block and return whatever the block outputs:

    Kaleidoscope.unique {|i| "user_#{i}" } #=> "user_0"

How does it work?
-----------------

It just uses named scopes behind the scenes. Each factory declaration defines
a new named scope with the provided name (or `factory` by default).

This means we don't touch *any* class. No methods are added on 
`ActiveRecord::Base`. 

If the named scope already exists (or you have a class method with that
same name), the factory declaration will fail with an `ArgumentError`.

But enough README, read the code, the factory declaration is 5 lines of code.
Literally.

Why?
----

Just a thought experiment, but it might turn out to be useful after all. All 
credit goes to [Jeremy McAnally][jeremy] for the original idea.

License
-------

Copyright (c) 2009 [Jeremy McAnally][jeremy] & [Nicolás Sanguinetti][foca] for [entp][].

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

[jeremy]: http://github.com/jeremymcanally
[foca]:   http://github.com/foca
[entp]:   http://entp.com