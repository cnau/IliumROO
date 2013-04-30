=begin
Copyright (c) 2009-2012 Christian Nau

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
=end
$: << File.expand_path(File.dirname(__FILE__) + '/../../')

require 'features/step_definitions/spec_helper.rb'
require 'game/login_states/start_login_state'

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
