=begin
Copyright (c) 2009-2012 Christian Nau

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
=end
$: << File.expand_path(File.dirname(__FILE__) + "/../../")

require "features/step_definitions/spec_helper.rb"
require 'game/objects/basic_owned_object'

Given /^a mocked player object$/ do
  @player_klass_1 = mock
  @player_klass_1.stubs(:verbs).returns({})

  @player_obj_1 = mock
  @player_obj_1.stubs(:class).returns(@player_klass_1)
end

And /^a mocked arguments hash$/ do
  args[:caller] = @player_obj_1
  args[:player] = @player_obj_1
end

And /^an instance of BasicOwnedObject$/ do
  @owned_object_1 = BasicOwnedObject.new
end

When /^I check the starting mode of the object$/ do
  @start_mode_1 = @owned_object_1.getmode
end

Then /^I will get the DEFAULT mode$/ do
end