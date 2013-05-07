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
require 'game/account_states/enter_world_state'

Given /^an instance of EnterWorldState$/ do
  @enter_world_state = EnterWorldState.instance
  @enter_world_state.should_not be_nil
end

Given /^this character list "([^"]*)" with a name of "([^"]*)"$/ do |char_id, name|
  if char_id.empty?
    @entity.expects(:characters).returns({})
  else
    @player_id = char_id
    @entity.expects(:characters).returns({char_id => {'object_id' => char_id, 'name' => char_id}}) if name.empty?
    unless name.empty?
      @entity.expects(:characters).twice.returns({char_id => {'object_id' => char_id, 'name' => name}})
      @expected_menu = "1. #{name}\nChoose a character to play: "
      @entity.expects(:send_to_client).with(is_a(String)) { |msg| @last_client_msg = msg }
      @entity.expects(:display_type).returns('NONE')
    end
  end
end

Given /^a mocked entity for EnterWorldState$/ do
  @entity = mock
end

Given /^the mocked entity is expecting a new state from EnterWorldState$/ do
  @entity.expects(:change_state).with(is_a(Class)) { |next_state| @next_state = next_state }
end

When /^I call the enter method of EnterWorldState$/ do
  @enter_world_state.enter @entity
end

Then /^I should get redirected to "([^"]*)" by EnterWorldState$/ do |next_state|
  @next_state.name.should eql next_state
end

Then /^I should get an appropriate menu for EnterWorldState$/ do
  @last_client_msg.should eql @expected_menu
end

Given /^the mocked entity has last client data of "([^"]*)" for EnterWorldState$/ do |last_client_data|
  @entity.stubs(:last_client_data).returns(last_client_data)
end

When /^I call the execute method of EnterWorldState$/ do
  @enter_world_state.execute @entity
end

Given /^a mocked GameObjectLoader for EnterWorldState$/ do
  @player_object = mock
  GameObjectLoader.expects(:load_object).with(@player_id).returns(@player_object)
end

Given /^the mocked entity has a mocked client for EnterWorldState$/ do
  @client = mock
  @entity.expects(:client).returns(@client)
end

Given /^the mocked player object is expecting to attach the entity client$/ do
  @player_object.expects(:attach_client).with(@client)
end

Given /^the old entity is expecting to detach client for EnterWorldState$/ do
  @entity.expects(:detach_client)
end

Then /^the new player object should become the entity$/ do
  @entity = @player_object
end

Given /^the player object is expecting a new state from EnterWorldState$/ do
  @player_object.expects(:change_state).with(is_a(Class)) { |next_state| @next_state = next_state }
end


Given /^a startup map of "([^"]*)" and start location of "([^"]*)" and expect to look for startup "([^"]*)"$/ do |startup_map, start_location, expect_startup|
  the_map_id = (startup_map.nil? or startup_map.empty? ? nil : startup_map)
  if the_map_id.nil?
    GameObjects.expects(:get_tag).with('startup', 'map').returns({}) if expect_startup == 'true'
  else
    GameObjects.expects(:get_tag).with('startup', 'map').returns({'object_id' => the_map_id})
    @startup_map = mock
    @startup_map.expects(:enter).with(@player_object, @player_object, nil)
    GameObjectLoader.expects(:load_object).with(the_map_id).returns(@startup_map)
  end
end

Given /^the player object has a map of "([^"]*)" and start location of "([^"]*)"$/ do |map_id, location|
  the_map_id = (map_id.nil? or map_id.empty? ? nil : map_id)
  the_location = (location.nil? or location.empty? ? nil : location)

  @player_object.stubs(:map).returns(the_map_id)
  @player_object.stubs(:location).returns(the_location)

  unless the_map_id.nil?
    @mock_map = mock
    @mock_map.expects(:enter).with(@player_object, @player_object, the_location)
    GameObjectLoader.expects(:load_object).with(the_map_id).returns(@mock_map)
  end
end