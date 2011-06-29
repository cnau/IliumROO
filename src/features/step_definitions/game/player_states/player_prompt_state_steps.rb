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
require "game/player_states/player_prompt_state"

Given /^an instance of PlayerPromptState$/ do
  @player_prompt_state = PlayerPromptState.instance
  @player_prompt_state.should_not be_nil
end

Given /^a mocked entity for PlayerPromptState$/ do
  @entity = mock
end

Given /^an entity expecting to receive a prompt for PlayerPromptState$/ do
  @entity.expects(:send_to_client).with(is_a(String)) {|msg| @client_msg = msg}
end

When /^I call the enter method of PlayerPromptState$/ do
  @player_prompt_state.enter @entity
end

Then /^I should get an appropriate prompt from PlayerPromptState$/ do
  @client_msg.should eql "\ncommand prompt > "
end

Given /^an entity expecting a change of state for PlayerPromptState$/ do
  @entity.expects(:change_state).with(is_a(Class)) {|next_state| @next_state = next_state}
end

When /^I call the execute method of PlayerPromptState$/ do
  @player_prompt_state.execute @entity
end

Then /^I should get redirected to "([^"]*)" by PlayerPromptState$/ do |next_state|
  @next_state.name.should eql next_state
end

Given /^an entity with last_client_data of "([^"]*)" for PlayerPromptState$/ do |last_client_data|
  @entity.stubs(:last_client_data).returns(last_client_data)
end

Given /^a mocked process_command method for PlayerPromptState$/ do
  @player_prompt_state.expects(:process_command).returns nil
end

Given /^an entity with a non\-nil client for PlayerPromptState$/ do
  @entity.expects(:client).returns(mock)
end

Given /^an entity with a nil client for PlayerPromptState$/ do
  @entity.expects(:client).returns(nil)
end