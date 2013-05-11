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

require_relative '../../spec_helper'

Given /^an instance of VerifyEmailState$/ do
  @verify_email_state = VerifyEmailState.instance
  @verify_email_state.should_not be_nil
end

When /^I call the enter method of VerifyEmailState$/ do
  entity = mock
  entity.expects(:email_address).returns('test_1@test.com')
  entity.expects(:send_to_client).with(is_a(String)) {|msg| @client_msg_1 = msg}
  @verify_email_state.enter entity
end

Then /^I should get appropriate output from VerifyEmailState 1$/ do
  @client_msg_1.should eql 'test_1@test.com, did I get that right?'
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