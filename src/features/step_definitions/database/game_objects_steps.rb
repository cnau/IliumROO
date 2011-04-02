#  This file is part of Ilium MUD.
#
#  Ilium MUD is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  Ilium MUD is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with Ilium MUD.  If not, see <http://www.gnu.org/licenses/>.
$: << File.expand_path(File.dirname(__FILE__) + "/../../")

require "features/step_definitions/spec_helper.rb"
require "database/game_objects.rb"

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