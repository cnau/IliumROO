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
require "game/account_states/add_character_state"

Given /^an instance of AddCharacterState$/ do
  @add_character_state = AddCharacterState.instance
  @add_character_state.should_not be_nil
end

When /^I call the enter method of AddCharacterState$/ do
  entity = mock
  entity.expects(:send_to_client).with(is_a(String)) {|msg| @client_msg_1 = msg}
  @add_character_state.enter entity
end

Then /^I should get appropriate output from AddCharacterState 1$/ do
  @client_msg_1.should eql "Enter new character's name:"
end

When /^I call the execute method of AddCharacterState with the name "([^"]*)" and the name is "([^"]*)"$/ do |character_name, available|
  entity = mock
  entity.expects(:last_client_data).returns(character_name)
  entity.expects(:change_state).with(is_a(Class)) {|next_state| @next_client_state = next_state}
  entity.expects(:send_to_client).with(is_a(String)) {|msg| @client_msg_2 = msg} unless character_name.empty?
  entity.expects(:name_available?).returns(true) if available == "available"
  entity.expects(:add_new_character).with(character_name) if available == "available"
  entity.expects(:name_available?).returns(false) if available == "unavailable"
  @add_character_state.execute entity
end

Then /^I should get "([^"]*)" and change to state "([^"]*)" from AddCharacterState$/ do |client_msg, next_state|
  # use start_with? here to avoid having to put a \n in the cucumber feature file
  @client_msg_2.start_with?(client_msg).should be_true unless client_msg.empty?
  @next_client_state.name.should eql next_state
end