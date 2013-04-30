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
$: << File.expand_path(File.dirname(__FILE__) + '/../../')

require 'features/step_definitions/spec_helper.rb'
require 'database/game_objects.rb'

OBJECT_ID = 'test_object_id_1'

Given /^a clean test object id$/ do
  GameObjects.remove OBJECT_ID

  obj = GameObjects.get OBJECT_ID
  obj.length.should eql 0
end

When /^I insert an object hash$/ do
  object_hash_1 = {:object_id => OBJECT_ID, :name => 'name'}
  GameObjects.save OBJECT_ID, object_hash_1
end

Then /^I expect that the object hash was inserted$/ do
  obj = GameObjects.get OBJECT_ID
  obj.length.should eql 2
  obj[:object_id].should eql OBJECT_ID
  obj[:name].should eql 'name'
end

And /^I clean up the test object id$/ do
  GameObjects.remove OBJECT_ID
  obj = GameObjects.get OBJECT_ID
  obj.length.should eql 0
end

When /^I insert an object hash with different columns$/ do
  @obj_hash_2 = { :object_id  => OBJECT_ID,
                  :super      => 'BasicObject',
                  :properties => 'foo,bar',
                  :foo_bar    => 'foo + bar'}

  GameObjects.save OBJECT_ID, @obj_hash_2
end

Then /^I expect that the object hash was inserted and is identical$/ do
  obj = GameObjects.get OBJECT_ID
  obj.should eql @obj_hash_2
end

Given /^a clean tag for object "([^"]*)"$/ do |arg1|
  GameObjects.remove_tag 'game_objects_steps', "test_object_name_#{arg1}"

  obj = GameObjects.get_tag 'game_objects_steps', "test_object_name_#{arg1}"
  obj.length.should eql 0
end

When /^I insert a new tag for object "([^"]*)"$/ do |arg1|
  GameObjects.add_tag 'game_objects_steps', "test_object_name_#{arg1}", {'object_id' => "test_object_id_#{arg1}"}
end

Then /^I expect object "([^"]*)" to be inserted$/ do |arg1|
  obj = GameObjects.get_tag 'game_objects_steps', "test_object_name_#{arg1}"
  obj.length.should eql 1
end

And /^I expect both objects to be inserted$/ do
  tags = GameObjects.get_tags 'game_objects_steps'
  tags.length.should eql 2
end

Then /^that I clean up object "([^"]*)"$/ do |arg1|
  GameObjects.remove_tag 'game_objects_steps', "test_object_name_#{arg1}"
  obj = GameObjects.get_tag 'game_objects_steps', "test_object_name_#{arg1}"
  obj.length.should eql 0
end