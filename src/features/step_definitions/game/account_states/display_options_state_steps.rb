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
require "game/account_states/display_options_state"

Given /^an instance of DisplayOptionsState$/ do
  @display_options_state = DisplayOptionsState.instance
  @display_options_state.should_not be_nil
end

When /^I have a display type of "([^"]*)" for the enter method$/ do |display_type|
  @entity = mock
  @entity.expects(:display_type).twice.returns(display_type)
  @entity.expects(:send_to_client).with(is_a(String)) {|msg| @client_msg = msg}
  @expected_menu = ""
  if display_type == 'ANSI'
    @expected_menu << "[blue]1.[white] turn off ANSI color\n"
  else
    @expected_menu << "[blue]1.[white] turn on ANSI color\n"
  end
  @expected_menu << "[white]choose and perish:"
  @expected_menu = Colorizer::colorize(@expected_menu, display_type)
end

When /^I call the enter method of DisplayOptionsState$/ do
  @display_options_state.enter @entity
end

Then /^I should get appropriate output from DisplayOptionsState enter method$/ do
  @client_msg.should eql @expected_menu
end

When /^I have a display type of "([^"]*)" for the execute method$/ do |display_type|
  @entity.stubs(:display_type).returns(display_type)
end

When /^I have a client data of "([^"]*)"$/ do |last_client_data|
  @entity.stubs(:last_client_data).returns(last_client_data)
end

When /^I call the execute method of DisplayOptionsState$/ do
  @display_options_state.execute @entity
end

Then /^I should get appropriate output from DisplayOptionsState execute method$/ do
  @client_msg.start_with?(@expected_msg).should be_true
end

Then /^I should get redirected to "([^"]*)" by DisplayOptionsState$/ do |destination_state|
  @destination_state.name.should eql destination_state
end

Given /^an entity expecting output of "([^"]*)"$/ do |sent_to_client|
  @expected_msg = sent_to_client
  @entity.expects(:send_to_client).with(is_a(String)) {|msg| @client_msg = msg}
end

Given /^a mocked entity$/ do
  @entity = mock
  @entity.expects(:change_state).with(is_a(Class)) {|state| @destination_state = state}
end

Given /^an entity expecting a display type of "([^"]*)"$/ do |display_type|
  @entity.expects(:display_type=).with(display_type)
end

Given /^an entity expecting to be saved$/ do
  @entity.expects(:save)
end
