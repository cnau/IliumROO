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
require "game/signup_states/start_signup_state"

Given /^an instance of StartSignupState$/ do
  @start_signup_state = StartSignupState.instance
  @start_signup_state.should_not be_nil
end

Given /^a mocked entity for StartSignupState$/ do
  @entity = mock
end

Given /^an entity with an email address of "([^"]*)" for StartSignupState$/ do |email|
  @entity.stubs(:email_address).returns(email)
end

When /^I call the enter method of StartSignupState$/ do
  @start_signup_state.enter @entity
end

Then /^I should get an appropriate response from StartSignupState$/ do
  @prompt.should eql @expected_prompt
end

Then /^I should get "([^"]*)" from StartSignupState$/ do |prompt|
  @prompt.start_with?(prompt).should be_true
end

Given /^an entity expecting to receive a prompt for StartSignupState$/ do
  @entity.expects(:send_to_client).with(is_a(String)) {|prompt| @prompt = prompt}
end

Given /^an entity with last_client_data of "([^"]*)" for StartSignupState$/ do |client_data|
  @entity.stubs(:last_client_data).returns(client_data)
end

Given /^an entity expecting a change of state for StartSignupState$/ do
  @entity.expects(:change_state).with(is_a(Class)) {|next_state| @next_state = next_state}
end

When /^I call the execute method of StartSignupState$/ do
  @start_signup_state.execute @entity
end

Then /^I should get redirected to "([^"]*)" by StartSignupState$/ do |next_state|
  @next_state.name.should eql next_state
end

Given /^a mocked client for StartSignupState$/ do
  @client = mock
  @client.stubs(:client_ip).returns("127.0.0.1")
end

Given /^a client expecting to set_last_login for StartSignupState$/ do
  @client_account.expects(:set_last_login).with("127.0.0.1")
end

Given /^a ClientAccount expecting to create a new client account with email "([^"]*)" and password "([^"]*)" for StartSignupState$/ do |email, password|
  @client_account = mock
  ClientAccount.expects(:create_new_account).with(email, password).returns @client_account
end

Given /^an entity and client expecting attach and detach client calls for StartSignupState$/ do
  @entity.expects(:client).returns(@client)
  @entity.expects(:detach_client)
  @client_account.expects(:attach_client).with(@client)
end

Given /^an entity with the mocked client for StartSignupState$/ do
  @entity.expects(:client).returns(@client)
end

Given /^a ClientAccount with account_count of "([^"]*)" for StartSignupState$/ do |account_count|
  ClientAccount.expects(:account_count).returns(account_count.to_i)
end

Given /^an entity with email address of "([^"]*)" for StartSignupState$/ do |email|
  @entity.stubs(:email_address).returns(email)
end

Given /^a mocked Password update function with password of "([^"]*)" for StartSignupState$/ do |password|
  Password.expects(:update).with(password).returns(password)
end

Given /^an ClientAccount expecting to receive a prompt for StartSignupState$/ do
  @client_account.expects(:send_to_client).with(is_a(String)) {|client_msg| @prompt = client_msg}
end

Given /^a ClientAccount expecting to get set as admin and saved$/ do
  @client_account.expects(:account_type=).with(:admin)
  @client_account.expects(:save)
end

Given /^a ClientAccount expecting a change of state for StartSignupState$/ do
  @client_account.expects(:change_state).with(is_a(Class)) {|next_state| @next_client_state = next_state}
end

Then /^the ClientAccount should get redirected to "([^"]*)" by StartSignupState$/ do |next_state|
  @next_client_state.name.should eql next_state
end