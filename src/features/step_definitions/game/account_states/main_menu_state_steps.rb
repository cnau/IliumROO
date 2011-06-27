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
require "game/account_states/main_menu_state"

Given /^an instance of MainMenuState$/ do
  @main_menu_state = MainMenuState.instance
  @main_menu_state.should_not be_nil
end

Given /^a mocked entity for MainMenuState$/ do
  @entity = mock
end

Given /^an entity expecting to receive a menu for MainMenuState$/ do
  @entity.expects(:send_to_client).with(is_a(String)) {|msg| @client_msg = msg}
end

Given /^an entity with account type of "([^"]*)" for MainMenuState$/ do |account_type|
  @entity.expects(:account_type).returns(account_type)
end

Given /^an entity with display type of "([^"]*)" for MainMenuState$/ do |display_type|
  @entity.expects(:display_type).returns(display_type)
end

When /^I call the enter method of MainMenuState$/ do
  @main_menu_state.enter @entity
end

Then /^I should get appropriate output from MainMenuState$/ do
  @client_msg.should eql @expected_msg
end

Given /^a generated main menu with account type of "([^"]*)"$/ do |account_type|
  @expected_msg = ""
  @expected_msg << "1. enter world\n"
  @expected_msg << "2. add character\n"
  @expected_msg << "3. delete character\n"
  @expected_msg << "4. set display options\n"
  @expected_msg << "5. quit\n"
  @expected_msg << "6. list accounts\n" if account_type.to_sym == :admin
  @expected_msg << "choose and perish:"
end

Given /^an entity expecting a change of state for MainMenuState$/ do
  @entity.expects(:change_state).with(is_a(Class)) {|next_state| @next_state = next_state}
end

When /^I call the execute method of MainMenuState$/ do
  @main_menu_state.execute @entity
end

Then /^I should get redirected to "([^"]*)" by MainMenuState$/ do |next_state|
  @next_state.name.should eql next_state
end

Given /^an entity with last_client_data of "([^"]*)" for MainMenuState$/ do |last_client_data|
  @entity.stubs(:last_client_data).returns(last_client_data)
end

Given /^a generated invalid option message for MainMenuState$/ do
  @expected_msg = "invalid option\n"
end
