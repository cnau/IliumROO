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