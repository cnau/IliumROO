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
require "game/account_states/delete_character_state"

Given /^an instance of DeleteCharacterState$/ do
  @delete_character_state = DeleteCharacterState.instance
  @delete_character_state.should_not be_nil
end

When /^I call the enter method of DeleteCharacterState with no characters$/ do
  entity = mock
  entity.expects(:characters).returns(nil)
  entity.expects(:change_state).with(is_a(Class)) {|state| @state_klass = state}
  @delete_character_state.enter entity
end

Then /^I should get redirected to "([^"]*)"$/ do |state_klass|
  @state_klass.name.should eql state_klass
end

When /^I call the enter method of DeleteCharacterState with character list "([^"]*)" and name list "([^"]*)"$/ do |character_id_list, character_name_list|
  entity = mock
  entity.expects(:characters).twice.returns(character_id_list)
  id_list = character_id_list.split(",")
  name_list = character_name_list.split(",")
  ctr = 0
  @expected_menu_2 = ""
  id_list.each {|id|
    entity.expects(:get_player_name).with(id).returns(name_list[ctr])
    @expected_menu_2 << "#{ctr+1}. #{name_list[ctr]}\n"
    ctr += 1
  }
  @expected_menu_2 << "Choose a character to delete: "
  entity.expects(:send_to_client).with(is_a(String)) {|msg| @client_msg_2 = msg}
  entity.expects(:display_type).returns("ASCII")
  
  @delete_character_state.enter entity
end

Then /^I should get appropriate output from enter method of DeleteCharacterState$/ do
  @client_msg_2.should eql @expected_menu_2
end

When /^I setup an entity with character list "([^"]*)" and name list "([^"]*)"$/ do |character_id_list, character_name_list|
  @entity = mock
  @entity.expects(:characters).returns(character_id_list) unless character_id_list.empty?
  @entity.expects(:change_state).with(is_a(Class)) {|state| @state_klass = state}
  @character_id_list = character_id_list
  @character_name_list = character_name_list
end

When /^a last_client_data of "([^"]*)"$/ do |last_client_data|
  @entity.stubs(:last_client_data).returns(last_client_data)
  id_list = @character_id_list.split(",")
  char_id = id_list[last_client_data.to_i - 1]
  if last_client_data.to_i < id_list.length
    @entity.expects(:remove_character).with(char_id)
    @entity.expects(:delete_character).with(char_id)
    char_name = @character_name_list.split(",")[last_client_data.to_i - 1]
    @entity.expects(:get_player_name).with(char_id).returns(char_name)
    @entity.expects(:send_to_client).with(is_a(String)) {|msg| @client_msg_3 = msg}
    @expected_msg = "Deleted #{char_name}.\n"
  end
end

When /^I call the execute method of DeleteCharacterState$/ do
  @delete_character_state.execute @entity
end

Then /^I should get appropriate output from DeleteCharacterState$/ do
  @client_msg_3.should eql @expected_msg
end
