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
