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
  @expected_msg = ''
  @expected_msg << "1. enter world\n"
  @expected_msg << "2. add character\n"
  @expected_msg << "3. delete character\n"
  @expected_msg << "4. set display options\n"
  @expected_msg << "5. quit\n"
  @expected_msg << "6. list accounts\n" if account_type.to_sym == :admin
  @expected_msg << 'choose and perish:'
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
