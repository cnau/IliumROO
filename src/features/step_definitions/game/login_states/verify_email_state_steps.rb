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
require "game/login_states/verify_email_state"

Given /^an instance of VerifyEmailState$/ do
  @verify_email_state = VerifyEmailState.instance
  @verify_email_state.should_not be_nil
end

When /^I call the enter method of VerifyEmailState$/ do
  entity = mock
  entity.expects(:email_address).returns("test_1@test.com")
  entity.expects(:send_to_client).with(is_a(String)) {|msg| @client_msg_1 = msg}
  @verify_email_state.enter entity
end

Then /^I should get appropriate output from VerifyEmailState 1$/ do
  @client_msg_1.should eql "test_1@test.com, did I get that right?"
end

When /^I call the execute method of VerifyEmailState with "([^"]*)"$/ do |verify_answer|
  entity = mock
  entity.expects(:last_client_data).returns(verify_answer)
  entity.expects(:change_state).with(is_a(Class)) {|state_class| @next_state_class = state_class}
  @verify_email_state.execute entity
end

Then /^I should change to the "([^"]*)"$/ do |next_state_class_name|
  @next_state_class.name.should eql next_state_class_name
end