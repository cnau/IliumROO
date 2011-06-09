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
require "game/login_states/start_login_state"

Given /^an instance of StartLoginState$/ do
  @start_login_state = StartLoginState.instance
  @start_login_state.should_not be_nil
end

When /^I call the enter method of StartLoginState$/ do
  entity = mock
  entity.expects(:email_address=).with(nil)
  entity.expects(:send_to_client).with(is_a(String)) {|msg| @client_msg_1 = msg}
  @start_login_state.enter entity
end

Then /^I should get appropriate output from StartLoginState 1$/ do
  @client_msg_1.should eql 'Email Address:'
end

When /^I call the execute method of StartLoginState with an invalid email$/ do
  entity = mock
  entity.stubs(:last_client_data).returns('invalid-email')
  entity.expects(:ctr).twice.returns(0)
  entity.expects(:ctr=).with(1)
  entity.expects(:send_to_client).with(is_a(String)) {|msg| @client_msg_2 = msg}
  entity.expects(:change_state).with(StartLoginState)
  @start_login_state.execute entity
end

Then /^I should get appropriate output from StartLoginState 2$/ do
  @client_msg_2.should eql "Invalid email.\n"
end

When /^I call the execute method of StartLoginState with an invalid email thrice$/ do
  entity = mock
  entity.stubs(:last_client_data).returns('invalid-email')
  entity.expects(:ctr).twice.returns 3
  entity.expects(:ctr=).with(4)
  entity.expects(:send_to_client).with(is_a(String)) {|msg| @client_msg_3 = msg}
  entity.expects(:change_state).with(LogoutState)
  @start_login_state.execute entity
end

Then /^I should get appropriate output from StartLoginState 3$/ do
  @client_msg_3.should eql "Invalid email.\n"
end

When /^I call the execute method of StartLoginState with a valid email and a nil account id$/ do
  entity = mock
  entity.stubs(:last_client_data).returns('test_4@test.com')
  entity.expects(:email_address=).with('test_4@test.com')
  entity.expects(:email_address).returns('test_4@test.com')
  ClientAccount.expects(:get_account_id).with('test_4@test.com').returns(nil)
  entity.expects(:ctr=).with(0)
  entity.expects(:change_state).with(VerifyEmailState)
  @start_login_state.execute entity
end

Then /^I should get appropriate output from StartLoginState 4$/ do
  #NOOP
end

When /^I call the execute method of StartLoginState with a valid email and a non\-nil account id$/ do
  entity = mock
  entity.stubs(:last_client_data).returns('test_5@test.com')
  entity.expects(:email_address=).with('test_5@test.com')
  entity.expects(:email_address).returns('test_5@test.com')
  entity.expects(:ctr=).with(0)
  ClientAccount.expects(:get_account_id).with('test_5@test.com').returns('ACCOUNT_ID_5')
  entity.expects(:account=).with('ACCOUNT_ID_5')
  entity.expects(:change_state).with(GetPasswordState)
  @start_login_state.execute entity
end

Then /^I should get appropriate output from StartLoginState 5$/ do
  #NOOP
end
