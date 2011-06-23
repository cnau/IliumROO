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
require "game/account_states/logout_state"

Given /^an instance of LogoutState$/ do
  @logout_state = LogoutState.instance
end

Given /^a mocked entity for LogoutState$/ do
  @entity = mock
  @client = mock
  @entity.stubs(:client).returns @client
  @entity.expects(:send_to_client).with(is_a(String)) {|msg| @client_msg = msg}
  @client.expects(:close_connection_after_writing)
  @entity.expects(:detach_client)
end

When /^I call the enter method of LogoutState$/ do
  @logout_state.enter @entity
end

Then /^I should get appropriate output from LogoutState$/ do
  @client_msg.should eql "bye\n"
end