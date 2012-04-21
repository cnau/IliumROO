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
require "game/player_states/player_prompt_state"

Given /^an instance of PlayerPromptState$/ do
  @player_prompt_state = PlayerPromptState.instance
  @player_prompt_state.should_not be_nil
end

Given /^a mocked entity for PlayerPromptState$/ do
  @entity = mock
end

Given /^an entity expecting to receive a prompt for PlayerPromptState$/ do
  @entity.expects(:send_to_client).with(is_a(String)) {|msg| @client_msg = msg}
end

When /^I call the enter method of PlayerPromptState$/ do
  @player_prompt_state.enter @entity
end

Then /^I should get an appropriate prompt from PlayerPromptState$/ do
  @client_msg.should eql "\ncommand prompt > "
end

Given /^an entity expecting a change of state for PlayerPromptState$/ do
  @entity.expects(:change_state).with(is_a(Class)) {|next_state| @next_state = next_state}
end

When /^I call the execute method of PlayerPromptState$/ do
  @player_prompt_state.execute @entity
end

Then /^I should get redirected to "([^"]*)" by PlayerPromptState$/ do |next_state|
  @next_state.name.should eql next_state
end

Given /^an entity with last_client_data of "([^"]*)" for PlayerPromptState$/ do |last_client_data|
  @entity.stubs(:last_client_data).returns(last_client_data)
end

Given /^a mocked process_command method for PlayerPromptState$/ do
  @player_prompt_state.expects(:process_command).returns nil
end

Given /^an entity with a non\-nil client for PlayerPromptState$/ do
  @entity.expects(:client).returns(mock)
end

Given /^an entity with a nil client for PlayerPromptState$/ do
  @entity.expects(:client).returns(nil)
end