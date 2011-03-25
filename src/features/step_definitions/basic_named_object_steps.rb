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
#  along with Ilium MUD.  If not, see <http://www.gnu.org/licenses/>

$: << File.expand_path(File.dirname(__FILE__) + "/../../")

require "features/step_definitions/spec_helper.rb"
require "game_objects/game_object_loader"
require "game/objects/basic_named_object"

Given /^a named game object instance$/ do
  @named_obj_0 = BasicNamedObject.new
  @named_obj_0.should_not be_nil
end

Then /^parent should be BasicNamedObject$/ do
  @named_obj_0.parent.should eql "BasicNamedObject"
end

Given /^a new named object instance$/ do
  @named_obj_1 = BasicNamedObject.new
  @named_obj_1.should_not be_nil
end

And /^a mocked game object save call$/ do
  GameObjects.expects(:save).with('persistent_object_2', is_a(Hash)) {|object_id, obj_hash| @object_hash_2 = obj_hash}
end

When /^I save it, I should get a new object id$/ do
  @named_obj_1.save
end

And /^I should have the correct properties in the hash$/ do
end

Then /^I should get an appropriate output message for the user$/ do
end