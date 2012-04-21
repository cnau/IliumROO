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
require "game/account_states/add_character_state"

Given /^an instance of AddCharacterState$/ do
  @add_character_state = AddCharacterState.instance
  @add_character_state.should_not be_nil
end

When /^I call the enter method of AddCharacterState$/ do
  entity = mock
  entity.expects(:send_to_client).with(is_a(String)) {|msg| @client_msg_1 = msg}
  @add_character_state.enter entity
end

Then /^I should get appropriate output from AddCharacterState 1$/ do
  @client_msg_1.should eql "Enter new character's name:"
end

When /^I call the execute method of AddCharacterState with the name "([^"]*)" and the name is "([^"]*)"$/ do |character_name, available|
  entity = mock
  entity.expects(:last_client_data).returns(character_name)
  entity.expects(:change_state).with(is_a(Class)) {|next_state| @next_client_state = next_state}
  entity.expects(:send_to_client).with(is_a(String)) {|msg| @client_msg_2 = msg} unless character_name.empty?
  entity.expects(:name_available?).returns(true) if available == "available"
  entity.expects(:add_new_character).with(character_name) if available == "available"
  entity.expects(:name_available?).returns(false) if available == "unavailable"
  @add_character_state.execute entity
end

Then /^I should get "([^"]*)" and change to state "([^"]*)" from AddCharacterState$/ do |client_msg, next_state|
  # use start_with? here to avoid having to put a \n in the cucumber feature file
  @client_msg_2.start_with?(client_msg).should be_true unless client_msg.empty?
  @next_client_state.name.should eql next_state
end