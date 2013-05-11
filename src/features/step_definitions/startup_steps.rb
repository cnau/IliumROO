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


require_relative 'spec_helper'

Given /^a mocked game config object with startup map of "([^"]*)" and room of "([^"]*)"$/ do |map_klass_name, starting_room|
  the_map_klass_name = nil if map_klass_name.empty?
  the_starting_room = nil if starting_room.empty?
  config_hash = {'startup' => {'map' => the_map_klass_name, 'room' => the_starting_room}}
  config_mock = mock
  config_mock.stubs(:[]).returns(config_hash)
  config_mock.stubs(:config).returns(config_hash)
  GameConfig.stubs(:instance).returns(config_mock)

  mock_map_klass = mock
  mock_map = mock
  mock_map_klass.expects(:new).once.returns(mock_map)

  the_map_klass_name ||= 'BasicContinuousMap'     # default value
  the_map_klass_name = 'BasicContinuousMap' if the_map_klass_name.empty?
  GameObjectLoader.expects(:load_object).once.with(the_map_klass_name).returns(mock_map_klass)

  mock_map.expects(:on_load).once
  mock_map.expects(:save).once
  mock_map.stubs(:to_s).returns('starting_map_id')
  mock_map.stubs(:game_object_id).returns('starting_map_id')

  starting_room = eval(the_starting_room) unless the_starting_room.nil?
  mock_map.expects(:start_location=).once.with(the_starting_room) unless the_starting_room.nil?

  GameObjects.expects(:add_tag).once.with('startup', 'map', is_a(Hash)) {|tag_name, sub_tag_name, tag_hash| @tag_hash = tag_hash;tag_name == 'startup' and sub_tag_name == 'map'}
end

When /^I start the game$/ do
  Startup::start_game
end

Then /^I should get map of type "([^"]*)" and room of "([^"]*)" created$/ do |map_klass_name, starting_room|
end

Given /^a mocked object tag indicating no previous game object created$/ do
  GameObjects.expects(:get_tag).with('startup', 'map').returns({}) {|tag_name, obj_id| tag_name == 'startup' and obj_id == 'game'}
  GameObjects.expects(:get_tag).with('startup', 'game').returns({}) {|tag_name, obj_id| tag_name == 'startup' and obj_id == 'game'}
end

Given /^a mocked game object$/ do
  mock_game_klass = mock
  mock_game = mock
  mock_game_klass.expects(:new).once.returns(mock_game)
  mock_game.stubs(:game_object_id).returns('mock_game_id')
  mock_game.expects(:save).once
  mock_game.expects(:port_list=).once.with(is_a(String)) {|port_list| @port_list = port_list}
  GameObjectLoader.expects(:load_object).once.with('Game').returns(mock_game_klass)
  mock_game.expects(:start).once
end

Then /^I should get game of type "([^"]*)" and port list of "([^"]*)" created$/ do |game_klass_name, port_list|
  @port_list.should eql port_list
end
