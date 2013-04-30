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
require 'game/account_states/logout_state'

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