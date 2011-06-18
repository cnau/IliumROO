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
require "game/account_states/enter_world_state"

Given /^an instance of EnterWorldState$/ do
  @enter_world_state = EnterWorldState.instance
  @enter_world_state.should_not be_nil
end

Given /^this character list "([^"]*)" with a name of "([^"]*)"$/ do |char_id, name|
  if char_id.empty?
    @entity.expects(:characters).returns(nil)
  else
    @player_id = char_id
    @entity.expects(:characters).returns(char_id) if name.empty?
    unless name.empty?
      @entity.expects(:characters).twice.returns(char_id)
      @entity.expects(:get_player_name).with(char_id).returns(name)
      @expected_menu = "1. #{name}\nChoose a character to play: "
      @entity.expects(:send_to_client).with(is_a(String)) {|msg| @last_client_msg = msg}
      @entity.expects(:display_type).returns("NONE")
    end
  end
end

Given /^a mocked entity for EnterWorldState$/ do
  @entity = mock
end

Given /^the mocked entity is expecting a new state from EnterWorldState$/ do
  @entity.expects(:change_state).with(is_a(Class)) {|next_state| @next_state = next_state}
end

When /^I call the enter method of EnterWorldState$/ do
  @enter_world_state.enter @entity
end

Then /^I should get redirected to "([^"]*)" by EnterWorldState$/ do |next_state|
  @next_state.name.should eql next_state
end

Then /^I should get an appropriate menu for EnterWorldState$/ do
  @last_client_msg.should eql @expected_menu
end

Given /^the mocked entity has last client data of "([^"]*)" for EnterWorldState$/ do |last_client_data|
  @entity.stubs(:last_client_data).returns(last_client_data)
end

When /^I call the execute method of EnterWorldState$/ do
  @enter_world_state.execute @entity
end

Given /^a mocked GameObjectLoader for EnterWorldState$/ do
  @player_object = mock
  GameObjectLoader.expects(:load_object).with(@player_id).returns(@player_object)
end

Given /^the mocked entity has a mocked client for EnterWorldState$/ do
  @client = mock
  @entity.expects(:client).returns(@client)
end

Given /^the mocked player object is expecting to attach the entity client$/ do
  @player_object.expects(:attach_client).with(@client)
end

Given /^the old entity is expecting to detach client for EnterWorldState$/ do
  @entity.expects(:detach_client)
end

Then /^the new player object should become the entity$/ do
  @entity = @player_object
end

Given /^the player object is expecting a new state from EnterWorldState$/ do
  @player_object.expects(:change_state).with(is_a(Class)) {|next_state| @next_state = next_state}
end